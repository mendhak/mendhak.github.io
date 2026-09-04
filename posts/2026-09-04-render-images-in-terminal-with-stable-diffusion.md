---
title: Image rendering in the terminal to aid with descriptive prose
description: Using kitty terminal graphics protocol to render images in the terminal to aid with reading
tags:
  - ebooks
  - terminal
  - text-to-image

---

Although I enjoy reading, having no mental imagery means that rich, descriptive passages are often lost on me. I will skip them and move on, not without feeling guilty about doing so. For this reason I've made attempts in the past to aid me, including [displaying rendered images on the Kobo](/posts/2024-03-24-kobo-text-to-images-with-stable-diffusion.md). This setup was a bit cumbersom, as I'd lose the changes on firmware updates or device resets. 

My latest tenuous attempt is to render the images in the terminal using the [kitty terminal graphics protocol](https://sw.kovidgoyal.net/kitty/graphics-protocol/), which is supported by a number of modern terminal emulators, including [WezTerm](/posts/2026-08-25-a-homepage-for-the-terminal.md).  


{% video "https://www.youtube.com/watch?v=Lj5dMBRozqM" %}

On the left I am reading an ebook using [epy reader](https://github.com/wustho/epy). I copy passages from it and paste it into my running script which waits for input. The script then passes the text, along with a JSON workflow, to ComfyUI; ComfyUI then generates the image and returns it to the script, which then renders it using a kitty graphics protocol library, [term-image](https://term-image.readthedocs.io/en/stable/start/tutorial.html). 

The advantages and disadvantages of this approach are the same. To benefit from this setup, I have to be reading at the computer. It's not as convenient as a Kobo, but isn't as many moving parts. I could just use this for books that are particularly rich in descriptions, at the moment it is the [Xeelee Sequence](https://en.wikipedia.org/wiki/Xeelee_Sequence) series by Stephen Baxter. The images aren't perfect, but good enough to help me along with the scene. 

## ComfyUI API, term-image, and the workflow JSON

The script is based on an [API call example to ComfyUI](https://github.com/Comfy-Org/ComfyUI/blob/master/script_examples/websockets_api_example_ws_images.py), which isn't well documented, but is enough to get started. In my case I've substituted the payload to use the Z Image Turbo model, and it's important to note that the workflow does not save images to disk, it just returns the image bytes back over the websocket connection. 

<details><summary>ComfyUI workflow JSON</summary>

```json
{ 
  "62": {
    "inputs": {
      "clip_name": "qwen_3_4b.safetensors",
      "type": "lumina2",
      "device": "default"
    },
    "class_type": "CLIPLoader",
    "_meta": {
      "title": "Load CLIP"
    }
  },
  "63": {
    "inputs": {
      "vae_name": "ae.safetensors"
    },
    "class_type": "VAELoader",
    "_meta": {
      "title": "Load VAE"
    }
  },
  "65": {
    "inputs": {
      "samples": [
        "70",
        0
      ],
      "vae": [
        "63",
        0
      ]
    },
    "class_type": "VAEDecode",
    "_meta": {
      "title": "VAE Decode"
    }
  },
  "66": {
    "inputs": {
      "unet_name": "z_image_turbo_bf16.safetensors",
      "weight_dtype": "default"
    },
    "class_type": "UNETLoader",
    "_meta": {
      "title": "Load Diffusion Model"
    }
  },
  "67": {
    "inputs": {
      "text": "The image description goes here, but it'll be replaced by the Python script anyway",
      "clip": [
        "62",
        0
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIP Text Encode (Prompt)"
    }
  },
  "68": {
    "inputs": {
      "width": 1024,
      "height": 1024,
      "batch_size": 1
    },
    "class_type": "EmptySD3LatentImage",
    "_meta": {
      "title": "EmptySD3LatentImage"
    }
  },
  "69": {
    "inputs": {
      "shift": 3,
      "model": [
        "66",
        0
      ]
    },
    "class_type": "ModelSamplingAuraFlow",
    "_meta": {
      "title": "ModelSamplingAuraFlow"
    }
  },
  "70": {
    "inputs": {
      "seed": 464678193752713,
      "steps": 8,
      "cfg": 1,
      "sampler_name": "dpmpp_2m",
      "scheduler": "karras",
      "denoise": 1,
      "model": [
        "69",
        0
      ],
      "positive": [
        "67",
        0
      ],
      "negative": [
        "71",
        0
      ],
      "latent_image": [
        "68",
        0
      ]
    },
    "class_type": "KSampler",
    "_meta": {
      "title": "KSampler"
    }
  },
  "71": {
    "inputs": {
      "text": "low quality, bad anatomy, extra digits, missing digits, extra limbs, missing limbs",
      "clip": [
        "62",
        0
      ]
    },
    "class_type": "CLIPTextEncode",
    "_meta": {
      "title": "CLIP Text Encode (Prompt)"
    }
  },
  "save_image_websocket_node": {
    "inputs": {
      "images": [
        "65",
        0
      ]
    },
    "class_type": "SaveImageWebsocket",
    "_meta": {
      "title": "Save Image (Websocket)"
    }
  }
}
```
</details>


The Python script I call runs in a loop, waiting for input. It adds the text to the JSON workflow as the input, and makes a call to ComfyUI. 

```python

while True:
    print("Paste your multiline prompt (press Enter twice to submit):")

    # input reading and validation 
    # ... snipped for brevity ... #

    prompt["67"]["inputs"]["text"] =  "Cinematic concept art, futuristic scifi high quality render: " + input_text

    # ... # 

    ws = websocket.WebSocket()
    ws.connect("ws://{}/ws?clientId={}".format("127.0.0.1:8188", client_id))
    images = get_images(ws, prompt)
    ws.close() 
```

ComfyUI receives the text, renders the image, and the response is processed by `get_images`, which grabs the image bytes out of the websocket response when it encounters the `save_image_websocket_node` node. 


```python
def get_images(ws, prompt):
    prompt_id = queue_prompt(prompt)['prompt_id']
    output_images = {}
    current_node = ""
    while True:
        out = ws.recv()
        if isinstance(out, str):
            # wait for execution to finish
            # ... snipped for brevity ... #
        else:
            if current_node == 'save_image_websocket_node':
                images_output = output_images.get(current_node, [])
                images_output.append(out[8:])
                output_images[current_node] = images_output

    return output_images
```

Finally the script takes those image bytes, passes it to PIL to convert it to an Image, and hand it to `term-image` to render. 

```python
{% raw %}
    for node_id in images:
        print("Images from node {}:".format(node_id))
        for image_data in images[node_id]:
            from PIL import Image
            import io
            image = Image.open(io.BytesIO(image_data))
            auto_image = AutoImage(image)
            auto_image.height = 30
            auto_image.width = 30
            print("{:1.1#}".format(auto_image))
{% endraw %}            
```

## Full Script

[Github Gist](https://gist.github.com/mendhak/487c320e2e86bdace438e2480930faa1)


