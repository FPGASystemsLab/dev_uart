
# UART Modules for FPGA Systems (dev_uart)

## Overview
This repository contains simple, independent UART transmit (TX) and receive (RX) modules, which can be utilized separately. This design allows for the implementation of multiple serial transmitters or receivers, like 16 serial transmitters or a significant number of receivers to collect incoming data from external devices, using minimal resources. 

The modules feature a 16-byte FIFO queue for both receiving and transmitting data, which smoothens the data flow. The FIFO queue is designed to be efficiently implemented as shift registers (SRLs) in Xilinx FPGAs or as a 16-element memory buffer in Lattice FPGAs. This leads to a compact realization of the module in both cases.

## Modules Description
### Transmit Module (TX)
The TX module (`serial_tx_box`) handles the transmission of data over UART. It includes a 16-byte FIFO for data buffering, a baud rate scaler, and manages the serialization of data bits for transmission. The module interfaces with the following signals:
- `CLK`: System clock signal.
- `RST`: System reset signal.
- `I_STB`: Input strobe/control signal indicating new data is ready to be transmitted.
- `I_DATA`: 8-bit input data to be transmitted.
- `I_ACK`: Acknowledgment signal indicating data has been successfully buffered.
- `O_TxD`: Serial output data line for UART transmission.
- `CFG_CLK_DIV`: 16-bit configuration input for setting the baud rate divider.

### Receive Module (RX)
The RX module (`serial_rx_box`) is responsible for receiving data over UART. It features a 16-byte FIFO queue, an interdomain filter, a baud rate scaler, and manages the deserialization of incoming data bits. The module interfaces with the following signals:
- `CLK`: System clock signal.
- `RST`: System reset signal.
- `I_RxD`: Serial input data line for UART reception.
- `O_STB`: Output strobe/control signal indicating received data is ready.
- `O_DATA`: 8-bit output data that has been received.
- `O_ACK`: Acknowledgment signal indicating the received data has been processed.
- `CFG_CLK_DIV`: 16-bit configuration input for setting the baud rate divider.

## Installation and Usage
To use these UART modules in your project, clone this repository and include the `aser_tx_box` and `aser_rx_box` modules in your FPGA design. Configure the modules according to your system's requirements.

### Cloning the Repository
```
git clone https://github.com/FPGASystemsLab/dev_uart.git
```

## Authors
- Adam Łuczak - [adam.luczak@outlook.com](mailto:adam.luczak@outlook.com)
- Jakub Siast - [jakusbsiast@gmail.com](mailto:jakusbsiast@gmail.com)

## Citation
To cite these UART modules in your research, please use the following BibTeX entry:
```
@misc{uart_fpgasystemslab,
  title = {UART Modules for FPGA Systems},
  author = {Adam Łuczak and Jakub Siast},
  year = {2024},
  publisher = {FPGASystemsLab},
  howpublished = {\url{https://github.com/FPGASystemsLab/dev_uart}}
}
```

## License
This project is open source and available under the MIT License. The license allows you to freely use, modify, and distribute the code in both private and commercial projects. However, it is important to note the following:

- **No Warranty**: The code is provided "as is" without any warranties of any kind, express or implied. The authors and contributors are not liable for any damages or losses that may arise from the use of the code.
- **No Liability**: In no event shall the authors or contributors be liable for any claim, damages, or other liability, whether in an action of contract, tort, or otherwise, arising from, out of, or in connection with the code or the use or other dealings in the code.
- **No Attribution Required**: While not required, attribution back to the original authors or the repository is appreciated. However, it is not a condition of the license.

By using this software, you agree to the terms of this license. If you do not agree with these terms, do not use the software.


## Contributing
Contributions to this project are welcome. Please feel free to fork the repository, make your changes, and submit a pull request.

## Contact
For any inquiries or questions regarding this project, please contact the authors at their respective email addresses.
