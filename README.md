# Implementation-of-IEEE-802.11a-WLAN-Physical-Layer-OFDM                                                                                                             My Project of the Advanced Wireless Communication Systems Course Offered in Spring 2022 @ Zewail City.

In this project, IEEE 802.11a WLAN Physical Layer (OFDM) is implmented. In OFDM, multiple closely spaced orthogonal subcarrier signals with overlapping spectra are transmitted to carry data in parallel. The number of subcarriers is 64, where only 48 subcarriers are used for the sake of data transmission and the rest of the 64 are zeroed to reduce adjacent channel interference. Convolutional encoding with rates 1/2, 2/3, and 3/4 are used for forward error correction. On the other hand, Veterbi decoder is used at the receiver to correct possible errors accumulated through noise. For channel estimation and equalization, both Zero Forcing (ZF), and Weiner Filter are used. Additionally, the modulation schemes that our implemented system supports are “BPSK”, “QPSK”, “16QAM” and “64QAM” with different rates up to 54 Mbps. The following diagram shows the main stages of our implmentation.

![image](https://user-images.githubusercontent.com/58476343/220197596-d39eead1-824b-4cfe-bedb-99eea56a4f0a.png)



## Transmitter Block Diagram <a name="Transmitter Block Diagram"></a>
![image](https://user-images.githubusercontent.com/58476343/220196989-e6c8f382-08e2-41c5-9ae3-2fac99b971ac.png)



## Transmitter:
Data is one of the most important parts in the frame. firstly, we tried to read the file correctly to transmite it by following the below steps

            1) FEC Coder: we use convolutional encoding for forward error correction with the following generator polynomials, g0 = 1011011, g1 = 1111001.
            2) Padding: to ensure that the whole data within the OFDM symbol will be mapped correctly with different types of Modulation.
            3) Symbol mapping: maps the bits to complex symbols according to each modulation type.
            4) The stream of complex numbers is divided into groups of 48 symbols and adding the pilots and the NULLs to pass it through IFFT with size 64.
            5) Adding cyclic prefix.
            6) Then sending the data across the channel.




## Receiver Block Diagram <a name="Receiver Block Diagram"></a>
![image](https://user-images.githubusercontent.com/58476343/220197073-8d63d300-0134-40f5-b25d-9a3f496b2a0a.png)


## Receiver:
Mainly, the reciver mission is to reverse each step happend at the transmiter (Coding, mapping,etc...) to receiver the data correctly.

            1) Removing cyclic prefix.
            2) Passing the data through FFT block.
            3) Frequency Equalization. 
            4) Symbol Demapping.
            5) FEC Decoder.
            
            
            
            
## Fixed-point implementation:
           
The design of this part is done using fixed-point representation. An efficient fixed-point design utilizes as minimum hardware resources as possible for each processing step while maintaining little to no performance degradation.


## Interleaving and scrambling:

In 802.11a, all the coded bits are interleaved to enhance the ability of the convolutional code to correct burst errors which might happen due to deep fades on some of the subcarriers. Interleaving improves the packet error rate performance of the system. Scrambling is done to make the transmitted data unintelligible; it could be as simple as XORing the data with a pseudorandom sequence that is known to both the transmitter and the receiver. The received data is then descrambled at the receiver.
