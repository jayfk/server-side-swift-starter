## Server Side Swift Starter
A starter template to develop and deploy swift applications with docker. 

### Features
- Swift 3.0 (SNAPSHOT-2016-03-24-a)
- Uses two environments for development and production.
- Code autoreload during development
- Kitura swift framework
- NGINX handles static files and acts as a reverse proxy for the swift application
- Pre configured MongoDB database, comes with an admin interface to create/backup databases
- Uses environment variables to store secrets

### Screenshots

![Hi from swift](https://dockify.io/content/images/2016/04/hi_from_swift.png)

![Swift JSON](https://dockify.io/content/images/2016/04/json.png)

![Admin Interface](https://dockify.io/content/images/2016/04/admin.png)

![Mongo Express](https://dockify.io/content/images/2016/04/mongo-express.png)

## Getting started
### Prerequisite

You'll need to have 

- docker
- docker-compose > 1.6.0
- docker-machine (optional)

installed on your mac. 

The easiest way to get them all is to download and install [docker-toolbox](https://www.docker.com/products/docker-toolbox). 
If you are completely new to docker, check out the [getting started with docker](https://docs.docker.com/mac/) guide.

Make sure you can run docker commands like `docker run hello-world` on your terminal, or use the docker quickstart terminal.

### Installation

Clone the template in a new directory (make sure to replace `NewProject` with your own project name) 
    
    git clone https://github.com/jayfk/server-side-swift-starter.git NewProject
    cd NewProject/
    
Remove all upstream git files, we don't need them.

    rm -rf .git/

Change the defaults with sed (make sure to replace the values in brackets, e.g `<user>` with `jayfk`)

    sed -i.tmp s/#ADMIN_USER#/<user>/g env/admin.env
    sed -i.tmp s/#ADMIN_PASSWORD#/<password>/g env/admin.env
    sed -i.tmp s/#PROJECT_NAME#/<NewProject>/g dockerfiles/swift/autoreload.sh dockerfiles/swift/Dockerfile Package.swift
    find . -type f -name \*.tmp -exec rm -f {} \;

## Developing locally

We are going to use docker to run our swift code during development and (later) in production. This
has a couple of huge benefits and a few drawbacks, but the most important thing is that we have consistent
environments.

First, build and start the stack with

    docker-compose -f dev.yml up
    
This will take *forever* on the first start. Docker has to pull all base images and has
to build our own images in `dev.yml`. This includes a full swift runtime linked to Foundation and the MongoDB
driver to name a few. Subsequent builds will be super fast, thanks to dockers caching.

While you wait, you can check out the [docker-compose getting started](https://docs.docker.com/compose/gettingstarted/) 
section in dockers docs. Our development environment is defined in `dev.yml` and uses the 
dockerfiles `dockerfiles/swift/Dockerfile-dev` and `dockerfiles/nginx/Dockerfiles`. This will give 
you a quick overview of what's taking so long.

As soon as your terminal stops spitting out text, you should see an output similiar to this

```
swift_1          | Compiling Swift Module 'LoggerAPI' (1 sources)
swift_1          | Compiling Swift Module 'KituraTemplateEngine' (1 sources)
swift_1          | Compiling Swift Module 'Socket' (3 sources)
swift_1          | Compiling Swift Module 'SwiftyJSON' (2 sources)
swift_1          | Compiling Swift Module 'BinaryJSON' (9 sources)
swift_1          | Compiling Swift Module 'KituraSys' (4 sources)
swift_1          | Compiling Swift Module 'MongoDB' (7 sources)
swift_1          | Compiling Swift Module 'KituraNet' (12 sources)
swift_1          | Compiling Swift Module 'Kitura' (13 sources)
swift_1          | Compiling Swift Module 'NewProject' (1 sources)
swift_1          | Linking .build/debug/NewProject
swift_1          | Setting up watches.  Beware: since -r was given, this may take a while!
swift_1          | Watches established.
```

Open up your browser with

    open "http://$(docker-machine ip dev)"

The code powering the application is in `Sources/main.swift`. Change the html string and hit save, you'll see
that the application is rebuilt automatically.

```
rebuild code here
```

Refresh your browser and you should see your changes.

*Pro tip: Add the IP `docker-machine ip dev` is putting out to `/etc/hosts` under the 
`docker.local` domain. For example: add a new line with `192.168.99.100 docker.local`. You will now
be able to connect to your app at http://docker.local/*


### Where to go from here

 - Take a look at the admin interface to create and backup databases at `http://your-ip/admin/`

 - The code in `Sources/main.swift` uses the Kitura framework. For more examples, take a look at the 
[Kitura example project](https://github.com/IBM-Swift/Kitura-Sample/blob/master/Sources/KituraSample/main.swift).

 - You can use whatever framework you like (or code your own!). Just make sure your code starts some 
kind of server and speaks HTTP on port 8090.

 - Dependencies are pulled in automatically using the [swift package manager](https://github.com/apple/swift-package-manager). 
 If you want to add a new dependency, add it to `Package.swift`.
 
 - [Create an Xcode Project](#creating-an-xcode-project)
    
    
## Deploying to production

Note: In this example we are going to use docker-machine to create a remote server on DigitalOcean
and install docker on it. The cool thing about docker-machine is that it works with a lot of 
[cloud providers](https://docs.docker.com/machine/drivers/) out of the box. I've found DigitalOcean
to be the easiest to get started, but if you are a fan of AWS/Microsoft Azure/Google Compute 
Engine or whatnot, just use them.

### Creating a Droplet with Docker Machine

You need an API access token to create a new server. Let's get one:

- Go to the Digitalocean [Console](https://cloud.digitalocean.com/login) and log in.
- Click on **API** in the header.
- Click on **Generate new token**
- Give the token a unique name, e.g *docker-machine*. Make sure that the write checkbox is checked.
 Otherwise docker-machine won't be able to create a new droplet.
- Click on **Generate Token**
- Copy the newly generated token and store it somewhere safe.

![DigitalOcean admin console](https://dockify.io/content/images/2016/04/digitalocean-api.png)

Now, let's create the machine:
  
    docker-machine create swiftapp --driver=digitalocean --digitalocean-region=nyc3 --digitalocean-size=512mb --digitalocean-access-token=YOUR_TOKEN

This will create a new 512MB Droplet in New York City 3 with the name *swiftapp*. If you want to 
create a Droplet of a different size or in a different datacenter, make sure to adjust 
`--digitalocean-size` and `--digitalocean-region` to your needs.

The command takes a couple of minutes to finish, the output should be similiar to this: 


```
Running pre-create checks...
Creating machine...
(swiftapp) Creating SSH key...
(swiftapp) Creating Digital Ocean droplet...
(swiftapp) Waiting for IP address to be assigned to the Droplet...
Waiting for machine to be running, this may take a few minutes...
Detecting operating system of created instance...
Waiting for SSH to be available...
Detecting the provisioner...
Provisioning with ubuntu(systemd)...
Installing Docker...
Copying certs to the local machine directory...
Copying certs to the remote machine...
Setting Docker configuration on the remote daemon...
Checking connection to Docker...
Docker is up and running!
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: docker-machine env swiftapp
```

    
*If you get any errors, remove the machine by running `docker-machine rm -f swiftapp`. If this 
also produces errors, you can always delete the Droplet using the Digitalocean web console as a 
fallback.*

### First Production Deployment

Select your production server with

    eval $(docker-machine env swiftapp)

This will set a couple of environment variables telling the docker client on our machine to talk
directly to the docker deamon on our server.

Now, we can start our stack on the server with
    
    docker-compose up -d

Don't worry, this will take a couple of minutes the first time. The docker deamon has to fetch all
 the images and install all the low level dependencies first. Subsequent builds will be a lot 
 faster since the image build process will be cached on the server. 
 
If you are bored, you can connect to the server and and launch `htop` to see what's happening 
under the hood.

    docker-machine ssh swiftapp
    apt-get install htop && htop 

Once ready, check out your shiny swift powered web app by running

    open "http://$(docker-machine ip swiftapp)"
    

### Subsequent Deployments

    docker-compose build swift
    docker-compose stop swift
    docker-compose start swift

## Useful things

### Creating an Xcode Project

To Create an Xcode project and open it (make sure to replace `NewProject` with your own project name)
    
    docker-compose -f dev.yml run swift swift build --generate-xcodeproj .
    open NewProject.xcodeproj
    
The generated project is mediocre at best. You'll probably see a lot of compile errors. To fix 
(most of) them, download and install the [March 24, 2016](https://swift.org/builds/development/xcode/swift-DEVELOPMENT-SNAPSHOT-2016-03-24-a/swift-DEVELOPMENT-SNAPSHOT-2016-03-24-a-osx.pkg)
development snapshot and change the toolchain in Xcode at `Preferences` > `Components` > `Toolchains`.

![Xcode Toolchains](https://dockify.io/content/images/2016/04/xcode_toolchains.png)

In order to get code highlighting and resolution to work, you need to select the modules manually.
In Xcode, locate your `main.swift` file at `Sources/main.swift` and select every imported module under
*Target Membership*. You'll still see *No such module* warnings, but the highlighting/resolution will 
work.

![Xcode dependencies](https://dockify.io/content/images/2016/04/xcode_dependencies.png)
