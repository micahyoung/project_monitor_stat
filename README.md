# project_monitor_stat
A command-line utility to run commands based on the overall build status of your Project Monitor projects. 

## Example

Note: This examples uses a [blink1 usb dongle](http://blink1.thingm.com/) and changes the light based on the build status using the handy command-line tool `blink1-tool`. You can execute any command line tool you want instead.

1. Set up your Project Monitor project and verify it works.
2. Edit your project and a unique tag to that you can use just for your personal build monitor.
  * For git and git-pair author detection (`-g`), set your tag to match your email username (ie: `micahyoung` when git config user.email is set to `micahyoung@my-project.com` or `pair+micahyoung+buddy@my-project.com`)
2. Install the gem: 
 ```sh
 gem install project_monitor_stat
 ```
 
3. Run the bin manually, with only the tag, to verify everything works.
 ```sh
 $ project_monitor_stat --tags micahyoung
 success
 ```
 
4. Add a `crontab` entry with callbacks.
  ```crontab
  * * * * * project_monitor_stat --tags micahyoung --success 'blink1-tool --green' --fail 'blink1-tool --red'
  ```

5. Push code, lights change.
6. Check out the other fancy options and customize!
