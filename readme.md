# Crypto App

Main page             |  News Page
:-------------------------:|:-------------------------:
<img src="https://github.com/randyefan/CryptoApp/blob/main/Resources/image1.png" width="350" height="700">  |  <img src="https://github.com/randyefan/CryptoApp/blob/main/Resources/image2.png" width="350" height="700">

My first app that I built with connection to websocket technology that provide real time communication between server and client. 

In this case, websocket is used for get real-time ticker data that always update almost every seconds.

Thankyou for RXSwift and RXCocoa that handle observer-observable for real time changes in the app.

I’m using MVVM architecture to reduced complexity in this project and makes the code more structure than using MVC architecture. 

Some third-party library that im using in this project, listed below: 

**1. Alamofire** - To handle request, response, and error network for connect the app to [min-api.cryptocompare.com](https://min-api.cryptocompare.com/documentation?key=Toplists&cat=topTotalTopTierVolumeEndpointFull)

**2. SwiftyJSON** -  to handle JSON Response from request network.

**3. RXSwift & RXCocoa** - to handle data binding, asynchronously task, and reactive programming on the Crypto App that I build using MVVM Architecture.

**4. Starscream** - to make the Crypto App working with websocket (well, this is my first experience working with websocket, and its fun :D)

### **_last but not least, dont forget to create your own api key on min-api.ctyptocompare.com and dont forget to "pod install". thank you😁_**
