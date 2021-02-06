# FIREBASE CRUD OPERATIONS on FLUTTER WEB and MOBILE


![homepage](/screenshots/homepage.png)

An example to show crud operations in firebase

## Pre-requisites
### Switch to Beta channel for Web production

This project was created with the following specs:
>#android studio 4.1.2   
>#compiled with Flutter 1.25.0-8.2.pre • channel beta  
>#Framework • revision b0a2299859  
>#Engine • revision 92ae191c17  
>#Tools • Dart 2.12.0 (build 2.12.0-133.2.beta)  
  
  
To switch to the beta channel, use the next 2 commands in a terminal:  
`flutter channel beta`  
`flutter upgrade`  
  
Check then your config with :  
`flutter devices`  

The terminal should then show something like this.  
>2 connected device:  
>  
>Web Server • web-server • web-javascript • Flutter Tools  
>Chrome     • chrome     • web-javascript • Google Chrome 81.0.4044.129  

In case you don't see any device, you can try  
`flutter config --enable-web`

### Create a new Firebase project

If you still have no account on Firebase, create one on  
>https://console.firebase.google.com/  

Create a new project. The name is just a label, but for this project use `firebase-crud-example`

![createproject](/screenshots/creaprogetto1.png)

Note that the Project-Id is created here. You can customize the Project-Id choosing a new one editing it with a click on the pencil icon.
You cannot edit it after the project is created, so try to find a better one (from the ones available) before going on.
Indeed, Firebase will create a web hosting for your app, that will be accessible at  
>https://[Project-Id].web.app  
and  
>https://[Project-Id].firebaseapp.com  

You DON'T need to enable Google Analytics for this project.  

Every time you create a project on Firebase, you are actually also creating a project into  
>https://console.cloud.google.com/  
Subscribe to it, and don't worry about inserting your credit card, the system will not charge you anything until you manually upgrade to a paid services.  

### Create an Android App  
![createandroid](/screenshots/creaandroid.png)

Click on the Android icon to make a new entry for the app we will create here.



In the next screen you will have to provide:  
###### The applicationId of your Android project
insert here  
>com.[yourcustomname].firebase_crud_example  
  
Note that in your future projects you should replace my id (example) with your own custom company or personal name.  
Note that you NEED to change this name in all these files:  
```
Android/app/build.gradle
Android/app/scr/Main/kotlin/com/[yourCompanyId]/firebase_crud_example/MainActivity.kt
Android/app/src/Main/AndroidManifest.xml
Android/app/src/Debug/AndroidManifest.xml
Android/app/src/Profile/AndroidManifest.xml
```
  
###### A label to this android app  
  
###### Your Sha-1 debug signature  
This signature comes from your machine and will always be the same, no matter what project you are working in.  
To retrieve your SHA-1 debug signature, open a terminal and use this command:  

MacOs:  
>keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore  
Windows:  
>keytool -list -v -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore  

The requested password is always 
>android

## Download the config file  

Save the google-services.json file in a secure place (NOT ON YOUR DESKTOP). You will need to insert a copy of this file into  
>Android/App  

Remember that this file should NEVER be included in a Repository, because it allows other people to access sensitive data connected to your personal Firebase account.  
When sharing this project to a trusted collaborator, you should send it in a separate and secure way.  

## Check that the dependencies are set  

Your build.gradle file should have these rows to work correctly:

```buildscript {
  repositories {
    // Check that you have the following line (if not, add it):
    google()  // Google's Maven repository
  }
  dependencies {
    ...
    // Add this line
    classpath 'com.google.gms:google-services:4.3.5'
  }
}

allprojects {
  ...
  repositories {
    // Check that you have the following line (if not, add it):
    google()  // Google's Maven repository
    ...
  }
}
```

Your App/build.gradle should also have these rows:

```apply plugin: 'com.android.application'
// Add this line
apply plugin: 'com.google.gms.google-services'

dependencies {
  // Import the Firebase BoM
  implementation platform('com.google.firebase:firebase-bom:26.4.0')

  // Add the dependencies for the desired Firebase products
  // https://firebase.google.com/docs/android/setup#available-libraries
}
```

# Activate your Google API
The app is now able to compile correctly, showing the app UI.


![homepage](/screenshots/homepage.png)

HOWEVER, the API from Google must be activated before your app can make requests to the Firebase Cloud.  

Trying to click on any of the buttons, or to make any CRUD operation on the database, will show an error:  


>W/Firestore(15045): (22.0.2) [WatchStream]: (8f993a7) Stream closed with status: Status{code=PERMISSION_DENIED, description=Cloud Firestore API has not been used in project [YOUR-PROJECT-ID] before or it is disabled. Enable it by visiting https://console.developers.google.com/apis/api/firestore.googleapis.com/overview?project=[YOUR-PROJECT-ID] then retry. If you enabled this API recently, wait a few minutes for the action to propagate to our systems and retry., cause=null}.
>W/Firestore(15045): (22.0.2) [OnlineStateTracker]: Could not reach Cloud Firestore backend. Connection failed 1 times. Most recent error: Status{code=PERMISSION_DENIED, description=Cloud Firestore API has not been used in project [YOUR-PROJECT-ID] before or it is disabled. Enable it by visiting https://console.developers.google.com/apis/api/firestore.googleapis.com/overview?project=[YOUR-PROJECT-ID] then retry. If you enabled this API recently, wait a few minutes for the action to propagate to our systems and retry., cause=null}

Note that the error show a specific web page that should be reached out to solve this issue.
`...Enable it by visiting https://console.developers.google.com/apis/api/firestore.googleapis.com/overview?project=[YOUR-PROJECT-ID]...`

The Link provided in the error log is clickable if you are using Android Studio.   
Just click it to go to the Google Cloud Api authorization page, and enable the key that was automatically created.

![enableapi](/screenshots/enableapi.png)

You can, alternatively, reach the Google console at  
https://console.developers.google.com/apis/dashboard
  
Then select the project from the dropdown list on the top of the page  
Then enable the Firebase API  


# Create the Database

The app is still not ready!
Trying to click the buttons, or to make any Database operation will give an error:  
>W/Firestore(16270): (22.0.2) [WatchStream]: (6f16a3d) Stream closed with status: Status{code=NOT_FOUND, description=The project fir-crud-example-42f94 does not exist or it does not contain an active Cloud Datastore or Cloud Firestore database. Please visit http://console.cloud.google.com to create a project or https://console.cloud.google.com/datastore/setup?project=[your-applicationId] to add a Cloud Datastore or Cloud Firestore database. Note that Cloud Datastore or Cloud Firestore always have an associated App Engine app and this app must not be disabled., cause=null}.
>W/Firestore(16270): (22.0.2) [OnlineStateTracker]: Could not reach Cloud Firestore backend. Connection failed 1 times. Most recent error: Status{code=NOT_FOUND, description=The project fir-crud-example-42f94 does not exist or it does not contain an active Cloud Datastore or Cloud Firestore database. Please visit http://console.cloud.google.com to create a project or https://console.cloud.google.com/datastore/setup?project=[your-applicationId] to add a Cloud Datastore or Cloud Firestore database. Note that Cloud Datastore or Cloud Firestore always have an associated App Engine app and this app must not be disabled., cause=null}

We need to activate the datastore. Let's open again our firebase console, and select the second tab on the left panel, named "Cloud Firestore".
On the next page, click "Create Database"

![createdb](/screenshots/creadatabase.png)

Select now "TEST MODE" to allow permission to write to everyone.
Normally the project will need a permission level to avoid everyone to read and write your data.
But for this project, we did not implement any authority system. And the data is not sensitive.
  
Select the location of your data, based on where your customers will mostly be located. (I select eur-3 because I live in Europe)  
  
Click now on Create Collection, and name it  
>users  

For this project, we have choosen to give the main Document the ID
>testusers  

You don't need to specify the fields. 
Creating the fields now will simply add the first record to the document. 
We don't need to create a first record for this project. Indeed, the Firebase Firestore is a No-SQL database, hence it is not a Relational Database. The documents can be different from each other, and we must not respect any scheme.
The Firebase Firestore is structured on a large JSON tree. Better remember this, because it means that every stored data is actually saved as a STRING.

# The app is finally working!

You can now run the example in your favorite IDE, connected to an Android Emulator or to a physical device.  
Having on the same screen your database console you can appreciate the data updating in real time.  
## Create the record
Try to click the "CREATE" button on the app.

![datainserted](/screenshots/datainserted.png)
  
Note that you can manually make all operations manually on the database.  
This allows you to control all your data without using any software. You only need a browser (and your credentials).  
## Read the record  
Click on the "READ" button.
The central caption will show "Data found: ...." with the custom data we issued in our code.
## Update the record  
Click on the "UPDATE" button.
The central caption will show "Record updated successfully: ..." with the new name we issued inside the code.
## Delete the record  
Click on the "DELETE" button.  
The central caption will show "Record deleted successfully"

Trying to read, update, or delete the record when it doesn't exist will show an error caption.

# Let's try Flutter-Web

The plugin cloud_firestore has a bug. It tries to request data to Firebase before initialeApp, and the error happens during the registration of the plugin.
So, the only way I found to make it work properly on Flutter-Web is to remove the cloud_firestore, and use the same commands found inside the plugin Firebase.
This forces us to comment out the plugin in pubspec.yaml before working with web plugins.  
Inside pubspec.yaml, comment out this line:  
`  #cloud_firestore: ^0.16.0`
  
and run
`flutter pub get`

REMEMBER that you will have to un-comment the same line every time you want to compile the project to mobile.  



Select now a different device for your build: Chrome 
Run the project with the green PLAY button on Android Studio, or with the terminal command:  
>flutter run -d chrome

Running the project, however, will lead to a blank page for now.  
Remember that you can always inspect the errors on a chrome page clicking 
> View > Developer > Developer Tools  

and selecting the "Console" tab

The error may seem confusing:  
>Failed to load module script: The server responded with a non-JavaScript MIME type of "text/html". Strict MIME type checking is enforced for module scripts per HTML spec.
>firebase-app.js:1 Uncaught (in promise) FirebaseError: Firebase: No Firebase App '[DEFAULT]' has been created - call Firebase App.initializeApp() (app/no-app).

Indeed, we called the initializeApp command at some point in the html file. Let's have a look at it. In your IDE, access the file:  
>web/index.html  

This file is the entry point of your Web-App. It only loads a Javascript file that is compiled by Flutter after the command `flutter build web`  


However, we note this line:  
`<script type="module" src="./firebase-config.js"></script>`

This file is not included in the repository. Exactly like the google-services.json file, it contains sensitive data on your personal access to your Firebase account, and thus should NEVER be included in a repository.

This data cannot be inputted manually. We must request to Firebase to create a web-app. Indeed, the configuration we already have was created for an Android App, and this is a totally different thing.  

# Let's create a new Web-App inside the Firebase Console.  

Go to the Overview page on your project and select "Add an App"
  
![addapp](/screenshots/addapp.png)

Click on the quote icon to create a Web App  

![webapp](/screenshots/webapp.png)
  
Register the web app with any label you prefer.
Tick the "Create a hosting" options to have a free hosting for your Web App, to be used later.
Note that the name of the app (and the address you will be able to reach it) is decided upon the applicationId, but that you can also try to find a better one (from the available ones), and that there is no rush. You can specify a different address later.  

The next page tells you what to add to the project to make it work with firebase.  
### Note that these specs are alreay inserted in this repository.  

You will need these lines into your HEAD section of the index.html  
to import the configuration and initialize the app, with the analytics (only if needed)  

  ```<script type="module" src="./firebase-config.js"></script>

  <script type="module">
  import { firebaseConfig } from './firebase-config.js';
  firebase.initializeApp(firebaseConfig);
  firebase.analytics();
  </script>
  ```
  
You will also need in your BODY section the following imports:  
  
>  <script src="https://www.gstatic.com/firebasejs/8.2.5/firebase-app.js"></script>
>  <script src="https://www.gstatic.com/firebasejs/8.2.5/firebase-firestore.js"></script>

Insert also the analytics library if you enabled it in the previous steps.
>  <script src="https://www.gstatic.com/firebasejs/8.2.5/firebase-analytics.js"></script>

Remember that, in case your app requires other libraries, you can find them on this website:  
>https://firebase.google.com/docs/web/setup#available-libraries

under "Available Firebase JS SDKs (from the CDN)"  


## Install npm and firebase-tools

npm is the Node Package Manager . If you haven't it, you won't be able to continue. 
Check the NPM website for more information on how to install it on your operative system.
https://www.npmjs.com/get-npm

After, install the Firebase Tools, needed to use commands from your terminal.  

`npm install -g firebase-tools`
  
# Retrieve the web-configuration

In your Firebase console, open the Overview page and select the app.  
  
  
![selectapp](/screenshots/selectapp.png)

Select the web app.  
  
  
![selectwebapp](/screenshots/selectwebapp.png)
  
  
Click on the "Configuration" radio button on the right.  

![selectconfig](/screenshots/selectconfig.png)

Here you can see the configuration. 

![getconfig](/screenshots/getconfig.png)

  
# Let's start using the firebase-tools
  
  
>firebase login
  
you need to login within the webpage that opens up and authorize the firebase CLI


(If you get an error with all the next commands, 
check that your file `/.firebaserc` contains the correct projectId)

run in terminal:  
>firebase init

move your cursor on "hosting" , press SPACEBAR, then press ENTER

when asked "What do you want to use as your public directory?"  answer
>build/web

(This is the folder where Flutter puts the web app after production)  

when asked "(rewrite all urls to /index.html)" answer n  
when asked "Set up automatic builds and deploys with GitHub? " answer n  
when asked "File build/web/index.html already exists.overwrite?" answer n  

Now run in terminal:  
>firebase use --add
  
Select your app and press enter.
Choose an alias (whatever you prefer)


### Now you can retrieve the configuration.

run in terminal 


>firebase apps:sdkconfig
  
  
Select the web app and press enter.

Create a file inside your project in the folder web (same folder as index.html) and insert the data in this way:  

```
export var firebaseConfig = {
        apiKey: "AIza%%%%%%%%%%%%%%%%%%%%%%%%%%%%m8Vg4",
        authDomain: "fir-crud-example-%%%%%.firebaseapp.com",
        projectId: "fir-crud-example-%%%%%",
        storageBucket: "fir-crud-example-%%%%%.appspot.com",
        messagingSenderId: "12%%%%%%%7",
        appId: "1:12%%%%%%%7:web:b%%%%%%%%%%%%%%%%%%%%e",
        measurementId: "G-J%%%%%%%%%%E"
      };
```

Sometimes the measurementId may be missing. Don't worry, it is only needed if you requested the Analytics features. However, lacking to insert it will lead to a Warning on your web-page.

# The app finally works!

Run the project with the green PLAY button on Android Studio, or with the terminal command:  
>flutter run -d chrome




# Build and deploy to Web

*Remember that the version uploaded to your hosting is the RELEASE version, not the debug or profile ones.*  
*So, it's always a good practice to build and test the app in Release mode before deploy.*

enter this commands in a terminal under your project root, but only if you already have completed the login-init procedure described above.  


>flutter build web
  
>firebase deploy

The terminal will print 2 links. One for the relative configuration page, and one for the actual address of the published web app.
Your app is now published, and you can share it the public, redirect a domain to it, and brag about it.  

![fullapp](/screenshots/fullapp.png)


# How can I force browsers to load the new version?

Yes. The browsers are evil. If you use always the same names for files, even when you upload a new version, the users will still have the OLD version cached. And the browser will ignore totally what you did in the new version.
But here's a trick you can use to force browsers to dump the old version:
In index.html the line  
` <script src="main.dart.js" type="application/javascript"></script>`
  
can be edited without breaking the app, adding a fake prop to the call in this way:  
` <script src="main.dart.js?version=1.0.5" type="application/javascript"></script>`

So, everytime you upload a new version of your web app, you should go up by 1 in this line, and, for coherence, in the third line of your pubspec.yaml  
`version: 1.0.5`. (not mandatory)  
  
This will force the evil browsers to reload the entire app.  
Doing so, (BEFORE `flutter build web`) you can be 100% sure that the client is not using an outdated version.  



# Thanks and apologies  

Please contact me for any typo/error/mistake that you encounter in this Repository. 
Pull requests are welcome.  

Make contact with me at  

https://www.linkedin.com/in/eugenio-amato-developer  

eugenioama@hotmail.com  


