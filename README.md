# Linux_security_checker
Analysis all security level and patch all vuln in Linux systems.

## Description
```
Linux security checker (lsc) is ' auto security check tools ' consisting of shell scripts.
It can executable on Debian/CentOS Linux servers or systems.


lsc can patch common-vulnerability in system witch are you want to set it auto. 
It perform automatically diagnoses security settings that are mainly overlooked during system operation, 
and automatically sets system security levels to recommended values using patch scripts based on diagnostic results. 
```


## Usage

1. clone the lcs repository.

  ```
  $ git clone https://github.com/miho030/Linux_security_checker.git
  ```
  
2. unzip all directory
  ```
  $ unzip Linux_security_checker.zip
  ```

3. move to ' check_script ' directory and grant a permission.
  ```
  $ cd check_script/
  $ chmod 644 inspection.sh
  ```

4. execute auto checking script.
  ```
  $ ./inspection.sh
  ```

5. check security chesk result (json file) and move to ' patch_script ' directory
  ```
  $ cd ../patch_script
  ```

6. grant permission and execute P_U-**.sh script (which you want to set)
  ```
  $ chmod 644 P-U-**.sh
  $ ./P-U-**.sh
  ```


## update
I'm considering about full automatic script. It can be auto scan the system and execute appropriate patch script according to the executed system environment.

these are discription of next up-to-date.
```
* full-auto scan, patch
* an environmentally friendly security patch script selection engine
* clean up all trash/tmp/unknown file
```

