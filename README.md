# Integration salesforce with Igloo
This app connects with Igloo site and pull data from it, and shows in a salesforce page section.
This document helps to understand how to run the POC into your Salesforce environment.
1.	Create a custom setting with the name “Igloo Settings” and API name “IglooSettings”.
2.	Add custom fields to the custom setting created 
3.	Add a configuration row in to custom setting “Setup > Develop > Custom Settings” and click on “Manage”. Click on New button. Fill Igloo credentials and community url. Save. 
4.	Create classes with the same name that are in the zip file.
5.	Create an Apex page and copy and paste the code from zip file.
6.	Go to the Opportunity tap and create a new one with any name.
7.	Into the new opportunity created find “Edit Layout” and click on it.
8.	Add a new section from “Fields” options (“Opportunity Layout”).
9.	Go to the “Visualforce Pages” option and add the apex page added to the section.
10.	Save the changes and see if the page shows the igloo info.







 
