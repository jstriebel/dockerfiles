# TrackMania Nations Forever Docker Image
## :checkered_flag: :car: :whale:

The docker image provides a wine environment to install and run TMNF, it does not contain the game.

To use the image, download the following files into a seperate directory:
* [run.sh](https://raw.githubusercontent.com/jstriebel/dockerfiles/master/tmnf/run.sh)
* [docker-compose.yaml](https://raw.githubusercontent.com/jstriebel/dockerfiles/master/tmnf/docker-compose.yaml)
* [tmnationsforever_setup.exe](http://trackmaniaforever.com/nations/)

e.g. by running
```
mkdir tmnf
cd tmnf
wget https://raw.githubusercontent.com/jstriebel/dockerfiles/master/tmnf/run.sh
wget https://raw.githubusercontent.com/jstriebel/dockerfiles/master/tmnf/docker-compose.yaml
wget http://files.trackmaniaforever.com/tmnationsforever_setup.exe
```

Make `run.sh` executable:
```
chmod +x run.sh
```

Then simply call `./run.sh` and follow the installation instructions.
By running `./run.sh` again, you can start the game, or open the settings with `./run.sh -s`.
Use `./run.sh -h` to see all options.

Your game settings and executables will be stored in the `data` directory, and are still available when re-building or re-pulling the image.
