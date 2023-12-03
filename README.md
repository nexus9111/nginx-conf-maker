# CNC - Create Nginx Conf
A simple yet powerful command-line tool for quickly generating customized Nginx configurations.

## About
The `cnc` Bash script simplifies the creation of Nginx configuration files for different domains. It supports setting up HTTP and HTTPS listeners, including redirects and proxy settings.

## Features
- Automatic generation of Nginx configurations.
- SSL support with Let's Encrypt.
- Easy customization with parameters for IP, port, and domain name.
- Option to either display the configuration in the terminal or save it to a file.

## How to Use
- Download the `cnc.sh` script.
- Make it executable with `chmod +x cnc.sh`.
- Run the script with the required parameters. For example:
`./cnc.sh --ip=192.168.1.1 --port=8080 --domain=example.com`
- For help, use ./cnc.sh --help.

## Making it a Native System Command
To use cnc as a native command from any directory:

- Move the script to a directory in your system's PATH, such as /usr/local/bin/: `sudo mv cnc.sh /usr/local/bin/cnc`
- Ensure the script is executable: `sudo chmod +x /usr/local/bin/cnc`
- Now, you can run cnc from anywhere in the terminal: `cnc --help`

## Requirements
- A Unix-based operating system.

## Contributing
Contributions are welcome! If you'd like to contribute, please fork the repository and submit a pull request.

## Licence
<a href="https://github.com/nexus9111/nginx-conf-maker/blob/master/LICENSE">MIT LICENSE</a>

## Author
- <a href="https://github.com/nexus9111">Joss C</a>
