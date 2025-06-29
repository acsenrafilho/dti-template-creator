<img src="https://raw.githubusercontent.com/acsenrafilho/dti-template-creator/refs/heads/main/docs/assets/repo-slogan.png" width=700>



# dti-template-creator

`dti-template-creator` is a set of shell scripts pipelines designed to create DTI (Diffusion Tensor Imaging) templates. This repository contains all the necessary scripts and instructions to generate high-quality DTI templates.

## Table of Contents

- [dti-template-creator](#dti-template-creator)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Features](#features)
  - [Requirements](#requirements)
  - [Installation](#installation)
  - [Usage](#usage)
  - [Contributing](#contributing)
  - [License](#license)
  - [Contact](#contact)

## Introduction

The `dti-template-creator` repository provides a comprehensive solution for creating DTI templates using shell scripts. These templates are essential for various neuroimaging analyses and research.

## Features

- Automated pipeline for creating DTI templates
- Easy to configure and run
- Generates high-quality templates suitable for neuroimaging research

## Requirements

- Unix-based operating system (Linux, macOS)
- Bash shell
- Required software: [FSL](https://fsl.fmrib.ox.ac.uk/fsl/docs/)

## Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/acsenrafilho/dti-template-creator.git
   ```
2. Navigate to the cloned directory:
   ```sh
   cd dti-template-creator
   ```
3. Ensure all required software and dependencies are installed (anyway, if there is an dependency missing, the script will notify you for further instructions).

## Usage

1. Configure the scripts according to your requirements:
   - Edit the configuration files (if any) to specify input data and parameters. This is based on small adjustments in the header section of the running script.

2. Run the main script to start the pipeline:
   ```sh
   ./build_template
   ```
   - Replace `build_template` with the actual entry point script name.

3. Follow the instructions provided by the scripts.

## Contributing

Contributions are welcome! If you have improvements or fixes, please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your changes.
4. Commit your changes (`git commit -m 'Add some feature'`).
5. Push to the branch (`git push origin feature-branch`).
6. Open a Pull Request.

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## Contact

If you have any questions or need further assistance, please contact the repository owner:

- GitHub: [acsenrafilho](https://github.com/acsenrafilho)
