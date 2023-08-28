Static site for code.mendhak.com.  This site uses the [Eleventy Satisfactory theme](https://github.com/mendhak/eleventy-satisfactory).




**Running it with Docker**

This will do the npm install and npm start together. 

```
docker compose up
```

Then browse to http://localhost:8080/


**Running it with Node**

Requires Node 18. First get all the dependencies. 

```
npm install
```

To serve the site, and watch for changes: 

```
npm run start
```

Then browse to http://localhost:8080/


To just build the site once (normally used for Github Actions): 

```
npm install
npm run build
```
