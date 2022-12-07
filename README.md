# Shift-Manager-Teams

### Description

As a result of numerous inquiries for Shift manager in Microsoft Teams. by Using a mailbox calendar, I made automation shifts in Microsoft Teams Auto attended or Call queues.
with Microsoft Graph we get data from the calendar and filter the relevant information. we are using Aure automation (SaaS) without dependence on a local on-premise side.
We schedule the script to be daily or weekly depending on your requirements.
Also, with incoming webhook we send you a message on the Teams Channel when the script assigned the agents (if you didn't write any information on the calendar the bot will send you a message)



# Requirements
* we using **Microsoft.Graph,MicrosoftTeams** moudles you need to import them to Azure Automation.
* the user need to be without mfa and with teams communications administrator.


# Creating App registration.

* Go to **App registration** in Azure. 

* Choose **name** and select **Register**.

![image](https://user-images.githubusercontent.com/55660350/202478020-c38e1743-d4d2-4955-b5ad-57655bfeede6.png)

![image](https://user-images.githubusercontent.com/55660350/202477598-b1498f1c-dea9-4ffe-b023-f7fe6c9c5c82.png)

* Click on : **"API permissions"** 

![image](https://user-images.githubusercontent.com/55660350/202478758-55454083-836b-4c94-a3f3-19d01b91db44.png)

  click on **add a permission**
  
 * Choose **Microsoft Graph** 
 
  ![image](https://user-images.githubusercontent.com/55660350/202479493-280dbbc9-3ea4-4b3e-8df2-47c04520590f.png)

* Choose **Application permissions**

![image](https://user-images.githubusercontent.com/55660350/202479721-dcbc9e5e-0cf0-4813-813f-8c7261455630.png)

* Choose **Calenars.Read**

![image](https://user-images.githubusercontent.com/55660350/202479888-122ec880-6717-4c55-b208-b5811740849f.png)

* Choose **Delegated permissions**

![image](https://user-images.githubusercontent.com/55660350/202482470-464f4fa5-300c-4aea-bfba-bbc67a1dcd7f.png)

* Choose **User.read**

![image](https://user-images.githubusercontent.com/55660350/202483050-a1835f2f-698d-43f7-abf8-184b8dafffe5.png)

when you finish to adding the permissions.

Click on **Grant admin consent..**

![image](https://user-images.githubusercontent.com/55660350/202483532-b2da338f-1fb1-4f8c-b7d0-8625262d58e3.png)

* Go to - **Certificates & secrets**

![image](https://user-images.githubusercontent.com/55660350/202484534-41a19dc2-70b6-45f5-9990-f965ee747612.png)

* Create a **New Client secret**

![image](https://user-images.githubusercontent.com/55660350/202484968-548df1a7-8aff-4287-8c62-2a64af2d23e8.png)

## please copy the Value it will be available only once (we will use with Value later in the script)

* go to **Overview**

![image](https://user-images.githubusercontent.com/55660350/202486451-1407ab38-323c-46f0-af9e-a500d416da3c.png)

Please copy - **Application (client) ID**,**Directory (tenant) ID**, and **Secret Value** 

![image](https://user-images.githubusercontent.com/55660350/202487067-ba32134c-8731-4e14-8d78-9783f539e063.png)

# azure Automation 
The first step is to create an Azure Automation Account in your Azure subscription.

1.On the Microsoft Azure portal click on Create a resource

![image](https://user-images.githubusercontent.com/55660350/203351247-b649ccea-e698-41e8-b0b3-d1b19c5802ee.png)

2. Search for Automation and click Create.

![image](https://user-images.githubusercontent.com/55660350/203352401-b1983ce6-7b15-4847-8124-2bcac0235d6b.png)

3. Enter the information like the example below: add a name, add a Resource group if you don't have one. click on Create now.

![image](https://user-images.githubusercontent.com/55660350/203352462-58eaf932-628e-48a6-9e6d-d74510a6334e.png)

The pricing of Azure Automation is based on the number of minutes that a job runs. With each subscription, you get **500 minutes** of job run time and **744 hours** for the watchers for free per month.
![image](https://user-images.githubusercontent.com/55660350/203352965-a2a3b4ec-8f78-48d7-b300-c8bff7b7d3d8.png)

So with the **500 free minutes**, you should be able to automate most of your daily tasks And every hour more cost only **$0.12**.

## Add powershell Modules : MicrosoftTeams and Microsoft.Graph. 

now after we have **Azure Automation Account**.
we have to add the PowerShell modules used in our Runbooks scripts.

* Click on **"Browse gallery"**.

![image](https://user-images.githubusercontent.com/55660350/203353935-dc61d9b6-eb64-4151-a4c3-f3933dd1597d.png)

* type **"Teams"** and import the Microsoft teams module.

![image](https://user-images.githubusercontent.com/55660350/203354049-af11f390-a7d3-47e4-89de-374853e00731.png)

 **same steps for the "Microsoft.Graph" module.**
 
![image](https://user-images.githubusercontent.com/55660350/204786392-66a28595-8b55-4d55-b93d-833fa40ca661.png)



### Add Azure Automation Credentials
we need to set Credentials to be used by Azure Automation into our Runbooks.

## Recommended settings :
* **Username format:** @yourdomain.onmicrosoft.com.
* **Password:** extremely complex and set to Never Expire.
* **Sync Status:** Cloud only.
* **Roles:** Required two Roles for this script -Teams communications administrator.
* **Licenses:** none.
* **MFA:** not supported.


** Note** -the Runbooks do not have direct access to your Account Credential.

 we need to create Credentials accounts, go to *Credentials* and click on "Add a credenital"
 please Create 

![image](https://user-images.githubusercontent.com/55660350/204748821-4b2b4dc0-a218-4eec-8fc2-c634d68d2f9d.png)

## Create a Runbook

Go to **Azure** -> **Azure Automation Account** -> ** Process Automation** -> **Runbooks** -> **Create a runbook* -> add Name and select PowerShell as Runbook type ->** Create**

Copy and Paste the following Script into the Runbook and you be sure to replace **<AzureAutomationCredential>** with your own values.
it should be your Credential name that you created before in **Azure Credential**.
before you publish the scripts you need fill your information in the script (Azure Credential name,name of the queue,etc.) 
  
 **Azure Credential**
![image](https://user-images.githubusercontent.com/55660350/204783866-61a4c688-777b-4684-acdb-9108d1038f19.png)
  
You need to provide the parameters of your App registration (What you created above(.
  
  * **tenantId** - provide your Office 365 Tenant Id or Tenant Domain Name.
  * **ClientID** - Provide Azure AD Application (client) Id of your app
  * **clientSecret** - Provide Application client **secret key**
  
  ![image](https://user-images.githubusercontent.com/55660350/204787533-26229f1b-d594-4a83-b1da-b9ebde1021c8.png)

*  please provide the Email address of your Shift mailbox.(**example** - name@domain.com)
  
  ![image](https://user-images.githubusercontent.com/55660350/204800353-d06f71a5-5a47-4094-8477-faf3a2095a3a.png)

 ### setup incoming webhook

now we build an incoming webhook that will send us a notification message after we change agents in the shift or send us a message if it's failed.
  

* open your teams click 3 dots next to the Team’s Name ->**Connectors**  

![image](https://user-images.githubusercontent.com/55660350/204803340-78290d46-46f6-4fb9-b2a2-65c4dd87c568.png)
  
* Choose **"Incoming Webhook"** and click on ** "Configure"**.
  
  ![image](https://user-images.githubusercontent.com/55660350/204803413-c56acfa8-3dab-4091-9fcc-c950a696c830.png)

* Choose a **name** and click **Create**
  
 ![image](https://user-images.githubusercontent.com/55660350/204803522-c35e695e-a43f-4752-91ad-aea92884f167.png)
 
* Copy the **URL**.
  
  now we need to go back to the script that we already published above.
  
  ## plesae provide the URI of the incoming webhook.

![image](https://user-images.githubusercontent.com/55660350/204804075-a863ed34-5c0a-4f63-b923-88138491ec7a.png)

## **plesae change the script to your timezone(you can check it by run : get-timezone and copy the Id to variable $TimeZone).**

![image](https://user-images.githubusercontent.com/55660350/206155110-c79f4c30-f405-4bd0-a9a7-3edbede99eac.png)

 **please add your **Call queue Identity** (guid Identity) Example below** :
  ![image](https://user-images.githubusercontent.com/55660350/204804915-835bcceb-6381-415d-be46-2eb4bc054ee1.png)

 **add again your Call queue Identity here (guid Identity) Example below** :
  
![image](https://user-images.githubusercontent.com/55660350/204805078-4a0c84d1-b9e6-45ee-92a4-e5d50894cc88.png)
  
 **please type your *title* for the Message Card.**
  
  ![image](https://user-images.githubusercontent.com/55660350/205995985-b13ac008-4b85-4942-a769-116602bc70fd.png)
  
## after you fill all the relevant information on the script **Click on Publish**
  
 ![image](https://user-images.githubusercontent.com/55660350/206184384-656e023b-1e6f-47b0-b5e2-3868e27f56d2.png)
 
 # Schedules tasks with Azure Automation 
  
 * Go to > **Schedules**
  
  ![image](https://user-images.githubusercontent.com/55660350/206185008-32251119-52e7-4452-a6aa-948eee74df1e.png)
  
 * Click on **"Add a Schedule**
  
  ![image](https://user-images.githubusercontent.com/55660350/206185287-225341e8-ab0d-4109-94e7-d23e9f48b565.png)
  
 * Click on **"Link a schedule to your runbook"** and **add a Schedule**
  
  ![image](https://user-images.githubusercontent.com/55660350/206185339-3a9bd0a5-38fb-4c78-87db-4f751c18a59b.png)


 * you can run the script on **Recurring mode** by **Hour,day,week (you can choose dayofweek),Month.**
  
  ![image](https://user-images.githubusercontent.com/55660350/206185936-6af8e385-0446-472a-a76f-4851fa3c71d3.png)
   
  ![image](https://user-images.githubusercontent.com/55660350/206189640-4bc386fe-5a8c-45f9-93cf-70c5b8e3c2e9.png)

  # Manage shift by calendar
  
  * **note** The calendar mailbox should be specific for shift management.
  * Open outlook calendar and **Create Event** 
  
  ![image](https://user-images.githubusercontent.com/55660350/206191424-e50c87e2-6466-48ac-b355-72b023d9d648.png)

 # Type **Email address** of the agents ( you can add **Multipale agants** by Add a **comma** between each user or add one user)
  
  ## Example:
  
  ![image](https://user-images.githubusercontent.com/55660350/206191630-b88235b1-9229-4f6b-bc2e-dc946b930fa4.png)

  
 ### in this way you will be able to manage a shift at a regular schedule
  
  # Test Runbook

* Create an event on your **outlook calendar** with the relevant agents.
* Run the runbook by click on **"Start"** 
  
  ![image](https://user-images.githubusercontent.com/55660350/206194251-58ea9d48-993b-48d1-aedd-d16e5f4b968f.png)

*   Check the job Status if Completed or faild.(you can click on the Status to see more info)

  ![image](https://user-images.githubusercontent.com/55660350/206194779-0d76841d-808d-4adf-8272-9d6ee264d338.png)
  
  **you can see full Output and Errors,Warnings Etc.**
 
  ![image](https://user-images.githubusercontent.com/55660350/206195867-1cf289d8-db5f-4fa9-83b2-2e413ce0fa20.png)

when the script **" Completed"** you will get notification on the teams channel with all the inforamtion.
  
  ![image](https://user-images.githubusercontent.com/55660350/206196598-71ff1eac-4365-463f-a47d-33dcc8f28aed.png)

## Note -"if you don't fill a daily event You will receive a message".
  
  ![image](https://user-images.githubusercontent.com/55660350/206196855-67231788-d790-4d21-a0d7-22432259dcca.png)

  
 
