
# UART Modules for FPGA Systems (dev_uart)

## Overview
This repository, part of the FPGASystemsLab organization, hosts the development of UART modules for FPGA systems, specifically focusing on separate transmit (TX) and receive (RX) functionalities.

## Modules Description
### Transmit Module (TX)
The TX module (`aser_tx_box`) handles the transmission of data over UART. It includes an input FIFO for data buffering, a baud rate scaler, and manages the serialization of data bits for transmission.

### Receive Module (RX)
The RX module (`aser_rx_box`) is responsible for receiving data over UART. It features an interdomain filter, a baud rate scaler, and manages the deserialization of incoming data bits.

## Installation and Usage
To use these UART modules in your project, clone this repository and include the `aser_tx_box` and `aser_rx_box` modules in your FPGA design. Configure the modules according to your system's requirements.

### Cloning the Repository
```
git clone https://github.com/FPGASystemsLab/dev_uart.git
```

## Authors
- Adam Łuczak - [adam.luczak@outlook.com](mailto:adam.luczak@outlook.com)
- Jakub S. - [jakusbsiast@gmail.com](mailto:jakusbsiast@gmail.com)

## Citation
To cite these UART modules in your research, please use the following BibTeX entry:
```
@misc{uart_fpgasystemslab,
  title = {UART Modules for FPGA Systems},
  author = {Adam Łuczak and Jakub S. and Maciej Kurc and Jakub Siast},
  year = {2024},
  publisher = {FPGASystemsLab},
  howpublished = {\url{https://github.com/FPGASystemsLab/dev_uart}}
}
```

## License
This project is open source and available under the MIT License. You are free to use, modify, and distribute the code both in private and commercial projects without the need to attribute the original authors.

## Contributing
Contributions to this project are welcome. Please feel free to fork the repository, make your changes, and submit a pull request.

## Contact
For any inquiries or questions regarding this project, please contact the authors at their respective email addresses.
