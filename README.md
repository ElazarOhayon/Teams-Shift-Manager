# Shift-Manger-for-Teams
### Description

As a result of numerous inquiries for Shift manager in Microsoft Teams. Using a mailbox calendar, I made automation shifts in Microsoft Teams Auto attended or Call queues. with Microsoft Graph we get data from the calendar and filter the relevant information. we are using Aure automation (SaaS) without dependence on a local on-premise side. We schedule the script to be daily or weekly depending on your requirements. also, we building an incoming webhook that sends you a message on the Teams Channel when the script assigned the agents (if you didn't write any information on the calendar he also send you a message)



# Requirements
* we using Microsoft.Graph,MicrosoftTeams moudles you need to import them to Azure Automation > **Install-Module** Microsoft.Graph
* the user need to be without mfa and with teams communications administrator.


# Creating App registration.

Go to **App registration** in Azure. 
>Choose name and select **Register**.

![image](https://user-images.githubusercontent.com/55660350/202478020-c38e1743-d4d2-4955-b5ad-57655bfeede6.png)

![image](https://user-images.githubusercontent.com/55660350/202477598-b1498f1c-dea9-4ffe-b023-f7fe6c9c5c82.png)

Click on : **"API permissions"** 

![image](https://user-images.githubusercontent.com/55660350/202478758-55454083-836b-4c94-a3f3-19d01b91db44.png)

  click on **add a permission**
  
 Choose **Microsoft Graph** 
 
  ![image](https://user-images.githubusercontent.com/55660350/202479493-280dbbc9-3ea4-4b3e-8df2-47c04520590f.png)

Choose **Application permissions**

![image](https://user-images.githubusercontent.com/55660350/202479721-dcbc9e5e-0cf0-4813-813f-8c7261455630.png)

Choose **Calenars.Read**

![image](https://user-images.githubusercontent.com/55660350/202479888-122ec880-6717-4c55-b208-b5811740849f.png)

Choose **Delegated permissions**

![image](https://user-images.githubusercontent.com/55660350/202482470-464f4fa5-300c-4aea-bfba-bbc67a1dcd7f.png)

Choose **User.read**

![image](https://user-images.githubusercontent.com/55660350/202483050-a1835f2f-698d-43f7-abf8-184b8dafffe5.png)

after you finish to adding the permissions.
Click on **Grant admin consent..**

![image](https://user-images.githubusercontent.com/55660350/202483532-b2da338f-1fb1-4f8c-b7d0-8625262d58e3.png)

Go to - **Certificates & secrets**

![image](https://user-images.githubusercontent.com/55660350/202484534-41a19dc2-70b6-45f5-9990-f965ee747612.png)

Create a **New Client secret**

![image](https://user-images.githubusercontent.com/55660350/202484968-548df1a7-8aff-4287-8c62-2a64af2d23e8.png)

## please copy the Value it will be available only once (we will use with Value later in the script)

go to **Overview**

![image](https://user-images.githubusercontent.com/55660350/202486451-1407ab38-323c-46f0-af9e-a500d416da3c.png)

Please copy - **Application (client) ID**,**Directory (tenant) ID**, and **Secret Value** 

![image](https://user-images.githubusercontent.com/55660350/202487067-ba32134c-8731-4e14-8d78-9783f539e063.png)










