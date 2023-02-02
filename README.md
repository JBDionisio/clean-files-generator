A simple command-line application for generating files to clean architecture apps.

## Params
-p path => caminho para o modulo: lib/app/modules/name  
-n name => nome de referencia daquele endpoint.  
-L num => layer da clean architecture (domain/external/infra)

## Layers
 domain 0 / external 1 / infra 2

## Config
```
cd path_project  
dart pub global activate --source path . 
```
Now, go to terminal window and use:  
clean_generator -p path -n name -L 0

