Small utility in Nim to display the contents of a directory in an Ascii tree.

For instance if given the full path to a folder called "www" it would return the following

```
www
|-- private
|    |-- app 
|    |    |-- php
|    |    |    |-- classes
|    |    |    +-- scripts
|    |    |-- settings
|    |    +-- sql
|    +-- lib
|         +-- ZendFramework-HEAD
+-- public
    |-- css
    |-- images
    +-- scripts
```

Ability to write to a file, pass in CLI, and hardcode the path available - might work.
