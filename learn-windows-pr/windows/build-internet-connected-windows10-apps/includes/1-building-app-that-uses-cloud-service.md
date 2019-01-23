---
zone_pivot_groups: platform-apps
---

::: zone pivot="uwp"

![Tech logo](../media/tech-uwp.png)

::: zone-end

::: zone pivot="wpf"

![Tech logo](../media/tech-wpf.png)

::: zone-end

::: zone pivot="windowsforms"

![Tech logo](../media/tech-windowsforms.png)

::: zone-end

In this unit, we'll use the Azure Cognitive Services [Image Search](https://docs.microsoft.com/azure/cognitive-services/bing-image-search/) feature to write part of an app designed to help teach English as a second language. The finished app will automatically provide a picture for any word within a block of text. Here's the scenario: imagine the user is reading about different types of food, and they come across a word they don't know. With this app they can click on the word **soup**, and see a picture of some soup.

::: zone pivot="uwp"

![Found image - Soup](../media/uwp-image-search4.png)

::: zone-end

::: zone pivot="wpf"

![Found image - Soup](../media/wpf-image-search4.png)

::: zone-end

::: zone pivot="windowsforms"

![Found image - Soup](../media/wf-image-search4.png)

::: zone-end

Obviously it would be challenging to create an app that contained an image of every possible type of food that could be referenced in text, and that's why using Bing's Image Search is a great solution.

This project will cover:

- Creating a free account with Azure.
- Signing up for the Azure Cognitive Services Image Search API.
- Creating a simple Windows app that takes words from the user, sends them to the cloud, and receives a link to an image.
- Displaying the image.


## Create an Azure account

The first step is to sign up for a free Azure account. Follow the instructions at [Create a free Azure account](https://azure.microsoft.com/free) to get started.

## Sign up for Cognitive Services

Next, you need to sign up with the Cognitive Services account. This is linked to your Azure account, and again, free trials are available.

Once you sign up for the Bing Image Search service, you'll be given a unique key. The key (a string of text, like a long password) is used by your app when it talks to the online service to distinguish your app from any other app. Here's the link you'll need to sign up for access and get the key: [Bing Image Search](https://azure.microsoft.com/services/cognitive-services/bing-visual-search/)

## Create the app

We're now going to build the part of our English Language teaching app that focuses on matching text and images. We'll leave the English instruction part for another time. Before we start, make sure you are running the latest version of Windows 10. Check by going to **Settings > Windows Update**.

1. Open Visual Studio, and go to **File > New > Project**

::: zone pivot="uwp"

2. Create an app of type **Visual C# / Windows Universal / Blank App (Universal Windows)** and call it **ShowMeAPicture**.

![File - New - Project](../media/uwp-image-search1.png)

3. Make sure to select an up-to-date SDK. When the target and platform dialog appears, select these options:

![Pick the latest SDK](../media/uwp-image-search2.png)

4. Now we can define our UI. For now, our UI is going to be extremely basic, and it will consist only of a **TextBox** (for entering search terms), and an **Image** control (for displaying the image). You can create one yourself, or copy the following XAML code and paste it into MainPage.xaml, replacing everything that is already there.

```XAML
<Page
    x:Class="ShowMeAPicture.MainPage"
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    xmlns:local="using:ShowMeAPicture"
    xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
    xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
    mc:Ignorable="d"
    Background="{ThemeResource ApplicationPageBackgroundThemeBrush}">

    <Grid>
       <Image x:Name="foundObjectImage" HorizontalAlignment="Center" Height="256" 
            Margin="0,195,0,0" VerticalAlignment="Top" Width="320"/>
        <TextBox x:Name="searchTermsTextBox" HorizontalAlignment="Left" 
            Margin="675,500,0,0" Text="" VerticalAlignment="Top" 
            PlaceholderText="Type some search terms" KeyDown="OnKeyDownHandler"/>
    </Grid>
</Page>
```

It should look something like this.

![XAML file view](../media/uwp-image-search3.png)

Now we can work on the C# code that takes the text from the **TextBox**, sends it to the Azure service, and gets a link to an image in return.

5. First we will declare some important values, and write the event handler called when the user enters text into the **TextBox**. The **SubscriptionKey** is very important. You'll have received it when you signed up for the Cognitive Services account. If you find the app doesn't work, it's most likely that this key is the reason, so be sure to add your key where it says **your key goes here**. 

```csharp
using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using Windows.Data.Json; 
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media.Imaging; 

namespace ShowMeAPicture
{
    public sealed partial class MainPage : Page
    {
        const string SubscriptionKey = "your key goes here";
        const string UriBase = "https://api.cognitive.microsoft.com/bing/v7.0/images/search";
       
        public MainPage()
        {
            this.InitializeComponent();
        }

        private void OnKeyDownHandler(object sender, KeyRoutedEventArgs e)
        {
            // If the user presses enter, read the search terms and use them to find an image.

            if (e.Key == Windows.System.VirtualKey.Enter && 
                    searchTermsTextBox.Text.Trim().Length > 0)
            {
                // Search for an image using Bing's Image Search API, using 
                // search term entered in the XAML text box.
                string imageUrl = FindUrlOfImage(searchTermsTextBox.Text);
                
                // Display the first image found.
                foundObjectImage.Source = new BitmapImage(new Uri(imageUrl, UriKind.Absolute));
           
            }
        }

        // Search code goes here.
       
    }
}
```
Now we will add the C# that calls the search API.

6. Copy the following code and paste it over the comment **// Search code goes here**.

```csharp
        struct SearchResult
        {
            public String jsonResult;
            public Dictionary<String, String> relevantHeaders;
        }

        private string FindUrlOfImage(string targetString)
        {
            // Call the method that does the search.
            SearchResult result = PerformBingImageSearch(targetString);
            
            // Process the JSON response from the Bing Image Search API 
            // and get the URL of the first image returned.
            JsonObject jsonObj = JsonObject.Parse(result.jsonResult);
            JsonArray results = jsonObj.GetNamedArray("value");
            JsonObject first_result = results.GetObjectAt(0);
            String imageUrl = first_result.GetNamedString("contentUrl");
            return imageUrl;
        }

        static SearchResult PerformBingImageSearch(string searchTerms)
        {
            // Create the web-based query required to talk to the Bing API
            string uriQuery = UriBase + "?q=" + Uri.EscapeDataString(searchTerms);
            WebRequest request = WebRequest.Create(uriQuery);
            request.Headers["Ocp-Apim-Subscription-Key"] = SubscriptionKey;
            HttpWebResponse response = (HttpWebResponse)request.GetResponseAsync().Result;
            string json = new StreamReader(response.GetResponseStream()).ReadToEnd();

            // Create the result object for return value
            var searchResult = new SearchResult()
            {
                jsonResult = json,
                relevantHeaders = new Dictionary<String, String>()
            };

            // Extract Bing HTTP headers
            foreach (String header in response.Headers)
            {
                if (header.StartsWith("BingAPIs-") || header.StartsWith("X-MSEdge-"))
                    searchResult.relevantHeaders[header] = response.Headers[header];
            }

            return searchResult;
        }
```

Here's a summary of what this code does.

- The method **PerformBingImageSearch(string searchTerms)** constructs a web query comprised of the URL of the Bing search API, your key, and the search terms, and sends it off to the web.

```csharp
 HttpWebResponse response = (HttpWebResponse)request.GetResponseAsync().Result;
```

- The Bing Image Search API does all the hard work of finding images, and returns a response in JSON format.

- The method **FindUrlOfImage(string targetString)** uses the WinRT JSON library to decode the response, and extracts the first of several responses contained within the JSON.

- The URL of the image is extracted, and finally this code takes the URL, and displays the image it points to in the Image control.

```csharp
foundObjectImage.Source = new BitmapImage(new Uri(imageUrl, UriKind.Absolute));
```

::: zone-end

::: zone pivot="wpf"

2. Create an app of type **Visual C# / WPF App (.NET Framework)** and call it **ShowMeAPicture**.

![File - New - Project](../media/wpf-image-search1.png)

3. We'll need to use some extra code from a NuGet package to help us process the return values from the search API. Go to **Project > Manage NuGet Packages**. Select **Browse**, enter **Newtonsoft.Json**, and then install the package, like this.

![File - New - Project](../media/wpf-image-search2.png)

For more information on NuGet, see the Windows Learn module "Introducing Visual Studio" in this learning path.

4. Now we can define our UI. For now, our UI is going to be extremely basic, and it will consist only of a **TextBox** (for entering search terms) and an **Image** control (for displaying the image). You can create one yourself, or copy the following XAML code and paste it into MainWindow.xaml, replacing everything that is already there.

```XAML
<Window x:Class="ShowMeAPicture.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:ShowMeAPicture"
        mc:Ignorable="d"
        Title="MainWindow" Height="450" Width="800">
    <Grid>
        <TextBox x:Name="searchTermsTextBox" HorizontalAlignment="Left" Height="23" 
            Margin="253,217,0,0" TextWrapping="Wrap" VerticalAlignment="Top" 
            Width="120" KeyDown="SearchTermsTextBox_KeyDown"/>
        <Image x:Name="foundObjectImage" HorizontalAlignment="Left" Height="137" 
            Margin="202,40,0,0" VerticalAlignment="Top" Width="215"/>
    </Grid>
</Window>
```

It should look something like this.

![XAML file view](../media/wpf-image-search3.png)

Now we can work on the C# code that takes the text from the **TextBox**, sends it to the Azure service and gets a link to an image in return.

4. First we will declare some important values, and write the event handler called when the user enters text into the **TextBox**. The **SubscriptionKey** is very important. You'll have received it when you signed up for the Cognitive Services account. If you find the app doesn't work, it's most likely that this key is the reason, so be sure to add your key where it says **your key goes here**. 

```csharp
using System;
using System.Collections.Generic;
using System.Windows;
using System.Windows.Input;
using System.Windows.Media.Imaging;
using System.IO;
using System.Net;
using Newtonsoft.Json.Linq;

namespace ShowMeAPicture
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        const string SubscriptionKey = "your key goes here";
        const string UriBase = "https://api.cognitive.microsoft.com/bing/v7.0/images/search";

        public MainWindow()
        {
            InitializeComponent();
        }

        private void SearchTermsTextBox_KeyDown(object sender, KeyEventArgs e)
        {
            // If there is a valid string in the text box, search for some images.
            // A valid string is any group of characters - even just one, except empty spaces.
            if (e.Key == Key.Enter && searchTermsTextBox.Text.Trim().Length > 0)
            {
                string imageUrl = FindUrlOfImage(searchTermsTextBox.Text);

                foundObjectImage.Source = new BitmapImage(new Uri(imageUrl, UriKind.Absolute));
            }
        }

     // Search code goes here
    }
}
```
Now we will add the C# that calls the search API.

5. Copy the following code and paste it over the comment **// Search code goes here**.

```csharp
struct SearchResult
        {
            public String jsonResult;
            public Dictionary<String, String> relevantHeaders;
        }

        private string FindUrlOfImage(string targetString)
        {
            // Call the method that does the search.
            SearchResult result = PerformBingImageSearch(targetString);

            // Process the JSON response from the Bing Image Search API 
            // and get the URL of the first image returned.
            JObject jResult = JObject.Parse(result.jsonResult);

            // Extract an array of "values" (search hits) from the large object returned.
            JArray values = (JArray) jResult["value"];

            // Take the first value as a string, and parse it into components.
            string firstResult = values[0].ToString();
            JObject jFirst = JObject.Parse(firstResult);

            // Extract the content string from the components, and return it as an image Url.
            string imageUrl = (string) jFirst["contentUrl"];
            return imageUrl;
        }

        static SearchResult PerformBingImageSearch(string searchTerms)
        {
            // Create the web-based query required to talk to the Bing API.
            string uriQuery = $"{UriBase}?q={Uri.EscapeDataString(searchTerms)}";
            WebRequest request = WebRequest.Create(uriQuery);
            request.Headers["Ocp-Apim-Subscription-Key"] = SubscriptionKey;
            HttpWebResponse response = (HttpWebResponse)request.GetResponseAsync().Result;
            string json = new StreamReader(response.GetResponseStream()).ReadToEnd();

            // Create the result object for return value.
            var searchResult = new SearchResult()
            {
                jsonResult = json,
                relevantHeaders = new Dictionary<String, String>()
            };

            // Extract Bing HTTP headers.
            foreach (String header in response.Headers)
            {
                if (header.StartsWith("BingAPIs-") || header.StartsWith("X-MSEdge-"))
                {
                    searchResult.relevantHeaders[header] = response.Headers[header];
                }
            }

            return searchResult;
        }

```
Here's a summary of what this code does.

* The method **PerformBingImageSearch(string searchTerms)** constructs a web query comprised of the URL of the Bing search API, your key, and the search terms, and sends it off to the web.

```csharp
 HttpWebResponse response = (HttpWebResponse)request.GetResponseAsync().Result;
```

* The Bing Image Search API does all the hard work of finding images, and returns a response in JSON format.

* The method **FindUrlOfImage(string targetString)** uses the Newtonsoft.Json library to decode the response, and extracts the first of several responses contained within the JSON.

* The URL of the image is extracted, and finally this code takes the URL, and displays the image it points to in the Image control.

```csharp
FoundObjectImage.Source = new BitmapImage(new Uri(imageUrl, UriKind.Absolute));
```

::: zone-end

::: zone pivot="windowsforms"

2. Create an app of type **Visual C# / Windows Forms App (.NET Framework)** and call it **ShowMeAPicture**.

![File - New - Project](../media/wf-image-search1.png)

3. We'll need to use some extra code from a NuGet package to help us process the return values from the search API. Go to **Project > Manage NuGet Packages**. Select **Browse**, enter **Newtonsoft.Json**, and then install the package, like this.

![File - New - Project](../media/wpf-image-search2.png)

For more information on NuGet, see the Windows Learn module "Introducing Visual Studio" in this learning path.

4. Now we can define our UI. For now, our UI is going to be extremely basic, and it will consist only of a **TextBox** (for entering search terms), and a **PictureBox** control (for displaying the image). Select **Form1.cs** and drag over **TextBox** and **PictureBox** from the toolbox. Name the TextBox **searchTerms** and the PictureBox **foundImage**.

At this point you should create an event handler to be fired when the user enters text. In the **Properties** pane, select the **Events** icon.

![Adding an event handler](../media/wf-image-search2.png)

Then select in the field by **KeyDown**. This will create the event handler for you, and you'll see the following method generated.

```csharp
private void searchTerms_KeyDown(object sender, KeyEventArgs e)
{
 
}
```

One more thing: set the PictureBox's **SizeMode** property to **Zoom** so that our image is resized properly.

![Setting sizemode to zoom](../media/wf-image-search3.png)

Now we can work on the C# code that takes the text from the **TextBox**, sends it to the Azure service, and gets a link to an image in return. Select **Form1.cs**.

4. First we will declare some important values, and write the event handler called when the user enters text into the **TextBox**. The **SubscriptionKey** is very important. You'll have received it when you signed up for the Cognitive Services account. If you find the app doesn't work, it's most likely that this key is the reason, so be sure to add your key where it says **your key goes here**. Replace the existing code in Form1.cs with this.

```csharp
using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Windows.Forms;
using Newtonsoft.Json.Linq;

namespace ShowMeAPicture
{
    public partial class Form1 : Form
    {
        const string SubscriptionKey = "your key goes here";
        const string UriBase = "https://api.cognitive.microsoft.com/bing/v7.0/images/search";

        public Form1()
        {
            InitializeComponent();
        }

     private void searchTerms_KeyDown(object sender, KeyEventArgs e)
        {
            // If there is a valid string in the text box, search for some images.
            // A valid string is any group of characters - even just one, except empty spaces.
            if (e.KeyCode == Keys.Enter && searchTerms.Text.Trim().Length > 0)
            {
                string imageUrl = FindUrlOfImage(searchTerms.Text);

                foundImage.ImageLocation = imageUrl;
            }
        }
    
    // Search code foes here.


    }
}
```

Now we will add the C# that calls the search API.

5. Copy the following code and paste it over the comment **// Search code goes here**.

```csharp
        struct SearchResult
        {
            public String jsonResult;
            public Dictionary<String, String> relevantHeaders;
        }

        private string FindUrlOfImage(string targetString)
        {
            // Call the method that does the search.
            SearchResult result = PerformBingImageSearch(targetString);

            // Process the JSON response from the Bing Image Search API and get the URL 
            // of the first image returned.
            JObject jResult = JObject.Parse(result.jsonResult);

            // Extract an array of "values" (search hits) from the large object returned.
            JArray values = (JArray)jResult["value"];

            // Take the first value as a string, and parse it into components.
            string firstResult = values[0].ToString();
            JObject jFirst = JObject.Parse(firstResult);

            // Extract the content string from the components, and return it as an image Url.
            string imageUrl = (string)jFirst["contentUrl"];
            return imageUrl;
        }

        static SearchResult PerformBingImageSearch(string searchTerms)
        {
            // Create the web-based query required to talk to the Bing API.
            string uriQuery = $"{UriBase}?q={Uri.EscapeDataString(searchTerms)}";
            WebRequest request = WebRequest.Create(uriQuery);
            request.Headers["Ocp-Apim-Subscription-Key"] = SubscriptionKey;
            HttpWebResponse response = (HttpWebResponse)request.GetResponseAsync().Result;
            string json = new StreamReader(response.GetResponseStream()).ReadToEnd();

            // Create the result object for return value.
            var searchResult = new SearchResult()
            {
                jsonResult = json,
                relevantHeaders = new Dictionary<String, String>()
            };

            // Extract Bing HTTP headers.
            foreach (String header in response.Headers)
            {
                if (header.StartsWith("BingAPIs-") || header.StartsWith("X-MSEdge-"))
                {
                    searchResult.relevantHeaders[header] = response.Headers[header];
                }
            }

            return searchResult;
        }
```

Here's a summary of what this code does.

* The method **PerformBingImageSearch(string searchTerms)** constructs a web query comprised of the URL of the Bing search API, your key, and the search terms, and sends it off to the web:

```csharp
 HttpWebResponse response = (HttpWebResponse)request.GetResponseAsync().Result;
```

* The Bing Image Search API does all the hard work of finding images, and returns a response in JSON format.

* The method **FindUrlOfImage(string targetString)** uses the Newtonsoft.Json library to decode the response, and extracts the first of several responses contained within the JSON.

* The URL of the image is extracted, and finally this code takes the URL, and displays the image it points to in the **PictureBox** control.

```csharp
foundImage.ImageLocation = imageUrl;
```

::: zone-end

## What is JSON?

[JSON](https://www.wikipedia.org/wiki/JSON) is a standard format for sharing data between apps and services. It's text-based, so you can look at it in Notepad, and it contains different fields and values. There are code libraries available to help you read and write data in JSON format.

Here's a part of a typical JSON result from the Image Query as it looks as plain text.

![JSON result as plain text](../media/uwp-image-search7.png)

However, when viewed using some JSON formatting, it looks little friendlier.

![JSON result formatted](../media/uwp-image-search6.png)

In this format, it's straightforward to process the file and extract the values you need, especially when using a code library of helper functions.

## Run it!

You can run the app by selecting F5. Type some text into the **TextBox** and press Enter. Hopefully you'll see an image appear!

::: zone pivot="uwp"
![Found image - Bicycle](../media/uwp-image-search5.png)
::: zone-end
::: zone pivot="wpf"
![Found image - Bicycle](../media/wpf-image-search5.png)
::: zone-end
::: zone pivot="windowsforms"
![Found image - Bicycle](../media/wf-image-search5.png)
::: zone-end

Does the application crash? The most likely cause for this happening is the incorrect or missing App key. Another possibility is a lack of internet access. For the sake of simplicity, the sample code doesn't include a check for network access.

> [!Important]
> Never share your API key! If you are posting sample code to GitHub or another public site, make sure to remove your key first. If you forget, go to the Azure control panel and regenerate the keys as soon as possible. For the sake of simplicity in this example, we are storing the key in a string constant, but this method is not recommended for an app that is submitted to the store. In practice, third party API keys shouldn’t be stored or used in a client app directly.
