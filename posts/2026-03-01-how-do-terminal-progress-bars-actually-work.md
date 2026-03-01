---
title: How do terminal progress bars actually work?
description: How the various kinds of terminal progress indicators and progress bars work behind the scenes and how to create them
tags:
  - python
  - linux
  - bash

---

Terminal progress indicators are a common sight in command-line applications, often used to show progress of long running tasks and ensuring users don't get bored. Implementing them in scripts these days is pretty straightforward thanks to various libraries, but I've been curious about how they actually work under the hood. 

The answer, at its core, is fairly trivial. Most progress indicators make use of the character `\r`, the carriage return character. The carriage return is actually what's called a **control** character, which moves the cursor back to the beginning of the line. That in turn allows the next output to overwrite the previous one. In other words, it's a crude animation technique. 

Most modern terminal emulators and environments support this behaviour just fine, and that is how most progress indicators are implemented which I'll show below. It'll even work with SSH sessions so you can have progress indicators in remote scripts.  

## Simple number indicator

Here's a classic in-place progress number indicator which simply counts to 20. Save it to a Python file and run it. 


```python
import time

num_steps = 20

for step in range(num_steps):
    # The \r is important, it moves the cursor back to the beginning of line
    print(f"Processing {step+1} / {num_steps}", end='\r')
    time.sleep(0.3)  

# Print a newline to move the cursor to the next line after the loop is done
# otherwise, the done message overwrites the last progress message
print("\nDone!")
```

Note the use of `end='\r'` in the print statement in the loop, which is how the in-place update is achieved. Importantly as well, the `\n`, the newline character on the final print statement is necessary to move the cursor along after the loop is done. Without the newline, the "Done!" message would overwrite the last progress message. 

<video controls>
<source src="/assets/images/how-do-terminal-progress-bars-actually-work/001.mp4" type="video/mp4">
</video>

## Single character spinner

Single character spinners are a common way to indicate that something is in progress without necessarily showing a percentage. Here, we select from a set of characters in a loop to give the illusion of a spinning animation. 

```python
import time

total = 20
chars = ["|", "/", "-", "\\"]

for step in range(total):
    current = step + 1
    selected_char = chars[step % len(chars)]
    print(f"\r{selected_char} Processing...", end="")
    time.sleep(0.3)

print("\nDone!")
```

The key is the use of the modulo operator `%`, to cycle through the characters in the `chars` list. Each time the loop iterates, it selects the next character based on the current step, creating a spinning effect.

<video controls>
<source src="/assets/images/how-do-terminal-progress-bars-actually-work/002.mp4" type="video/mp4">
</video>

You can play around with the characters in the `chars` list to create different styles of spinners. Substitute the `chars` list as shown here: 

```python
chars = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"]
```

This creates:

<video controls>
<source src="/assets/images/how-do-terminal-progress-bars-actually-work/003.mp4" type="video/mp4">
</video>

See if you can find other interesting characters to use as spinners, here I've used the moon phase emojis: 


<video controls>
<source src="/assets/images/how-do-terminal-progress-bars-actually-work/002b.mp4" type="video/mp4">
</video>

### With a ✔ checkmark

You can take it a step further and replace the final progress message with a checkmark to indicate completion, and this is a fairly common pattern. The way it works, instead of a newline in the last message, we use another carriage return to overwrite the last progress message. 

```python

import time

total = 20
chars = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"]

for step in range(total):
    current = step + 1
    selected_char = chars[step % len(chars)]
    print(f"\r{selected_char} Processing...", end="")
    time.sleep(0.3)

print(f"\r✔ Done!                   ") # Extra spaces to overwrite any remaining characters from the last progress message
```

Here it is:

<video controls>
<source src="/assets/images/how-do-terminal-progress-bars-actually-work/003b.mp4" type="video/mp4">
</video>



## A progress bar

Now that we understand the basics of in place updates, progress **bars** aren't that much more complicated. The idea is to create a string that visually represents the progress using a blocky character that fills up a space. 

Try this in a file:

```python
import time

total = 20
for step in range(total):
    current = step + 1
    percent = current / total

    bar_length = 20
    filled = int(bar_length * percent)
    bar = "█" * filled + "-" * (bar_length - filled)

    print(f"\rProcessing: [{bar}] {current}/{total}", end="")

    time.sleep(0.1)

print("\nDone!")
```

The `bar` string is constructed by repeating the "filled" character `█` for the completed portion and the `-` character for the remaining portion. 

<video controls>
<source src="/assets/images/how-do-terminal-progress-bars-actually-work/004.mp4" type="video/mp4">
</video>


### Bouncing dot progress bar

A variation on the progress bar, when you don't have a known total, is to create a bouncing dot progress bar. In this example, the dot moves forwards or backwards depending on whether its position is less than or greater than the bar length. 

```python
import time

bar_length = 20

for i in range(70):

    pos = i % (bar_length * 2)
    # reverse direction
    if pos >= bar_length:
        pos = (bar_length * 2) - pos - 1
        
    bar = ["-"] * bar_length
    bar[pos] = "●" # moving dot
    
    print(f"\rProcessing: [{''.join(bar)}]", end="", flush=True)
    time.sleep(0.05)
print("\nDone!")
```

Here it is: 

<video controls>
<source src="/assets/images/how-do-terminal-progress-bars-actually-work/005.mp4" type="video/mp4">
</video>


## Two progress indicators at once

You might even want to have two progress indicators at once, for example a parent task and nested subtasks. 

This does get trickier, as we have to make use of two control sequences, `\033[A` for "cursor up", and `\033[K` for "clear line". 

In this example, we print two lines to reserve space for the progress indicators. Then in each loop, move the cursor up two lines to update the overall progress, then move to the next line to update the loop progress. 

```python
import time
import sys

MOVE_UP = "\033[A"    # this will move the cursor up 1 line
CLEAR_LINE = "\033[K"  # this will clear the current line

overall_iterations = 3
loops = 10

# We print two empty lines first to "reserve" the space
print("\n\n", end="") 

for iteration in range(overall_iterations):
    for loop in range(loops):
        # Move up 2 lines to update the overall progress
        sys.stdout.write(f"{MOVE_UP}{MOVE_UP}")
        print(f"{CLEAR_LINE}Overall Progress ({iteration+1}/{overall_iterations})")
        
        # Move to the next line to update loop status
        print(f"{CLEAR_LINE}Processing: [{'#' * (loop+1)}{'-' * (loops-loop-1)}] {loop+1}/{loops}")
        
        sys.stdout.flush()
        time.sleep(0.2)

print("\nDone!")
```

So to put it another way, we are using the control sequences to move around on the terminal 'space' to update relevant lines and make it look like we have two progress indicators at once.

<video controls>
<source src="/assets/images/how-do-terminal-progress-bars-actually-work/006.mp4" type="video/mp4">
</video>


## What you should use

The examples here are meant to be educational, or for quick-and-dirty progress indicators without dependencies. 

In practice, for production grade scripts, you should consider using a library such as [tqdm](https://github.com/tqdm/tqdm) or [rich](https://rich.readthedocs.io/en/latest/progress.html). They handle a lot of edge cases and have many features and effects that you can easily use.  