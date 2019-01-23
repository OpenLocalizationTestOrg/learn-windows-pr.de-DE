## Debugging basics

It's difficult to write code that has no errors the first time. Or even the second time. Here are some ways to use Visual Studio to find those pesky little bugs in your code (or great big ones).

## Simple debugging

The simplest way to debug an app is to simply add some 'print' statements in your project, to see which code is actually running. It's surprising how often bugs are caused when code that you thought was running, well, isn't. However, littering your project with messages isn't recommended for anything but the simplest cases.

Here's how to add these messages to the Universal Windows Platform (UWP) project you created in the previous unit.

1. In the Solution Explorer view on the right, select **MainPage.xaml** to expand it, and then select **MainPage.xaml.cs**. This is the C# code that is associated with the main window that your app will display.

![image of Visual Studio](../media/debug1.png)

2. Scroll down the source code editor window until you find the following.

```csharp
public MainPage()
{
    this.InitializeComponent();
}
```

Change it to read the following.

```csharp
public MainPage()
{
    this.InitializeComponent();
    Hello();
}

public void Hello()
{
    System.Diagnostics.Debug.WriteLine("Hello!");
}
```

It should look like this.

![image of Visual Studio](../media/debug2.png)

3. Run the project, by pressing F5 or selecting the green **Run** button. After a few seconds, your app will launch as a large, empty window. Minimize this window to bring Visual Studio back into view.

4. To see the message, you will need to make the Visual Studio **output window** visible. Press **Ctrl W** and then **O**, or go to the menu option **View** > **Output**, and you'll see the greeting.

> [!NOTE]
> This also works for displaying debug text in WPF and Windows Forms apps.

## Better debugging

Now we'll use breakpoints to stop an app in its tracks and find out what is going on inside it.

1. Stop the app from running, and update the **Hello()** method to look like this:

```csharp
public void Hello()
{
    int a = 1;
    int b = 2;
    int c = a + b;

    if (c == 4)
    {
        // Success
    }
    else
    {
        // Fail
    }
}
```

This app really wants to get the value 4. Unfortunately, there's a bug because a + b is currently equal to 3. Let's add a breakpoint to examine what is happening.

2. Click in the margin at the far left of the screen, by the line of code **int c = a + b;**. A red dot will appear - this is your *breakpoint* - and it will look like this:

![image of Visual Studio](../media/debug3.png)

3. Press **F5** or select **Run** again. This time, the app will immediately stop and bring Visual Studio back to the foreground. A small yellow arrow will appear in the margin, and a line of code will be highlighted in yellow. This shows you the line of code that will be executed next.

4. Hover the pointer over the variable **c**, and a little pop-up will show you its current value. It is 3, not 4 like our code expected! Looks like we found the bug!

![image of Visual Studio](../media/debug4.png)

5. While your program is paused, you can step through it line-by-line by using the **Step into**, **Step over**, and **Step out** buttons in the toolbar. Try it now — select **Step over** and watch the yellow arrow as it follows the flow-of-control.

![image of Visual Studio](../media/debug5.png)

6. If you move your pointer down to hover near one of the closing braces, a little green arrow will appear. This provides the useful ability to keep running the app until that location is reached. Try it out.

## The philosophy of debugging

A quick word on debugging. Knowing the tools at your disposal is half the battle, but understanding why things aren't working can take experience, coffee, patience, and a degree of luck. Here are some tips when things seem bleak:

- Consider that your code is doing exactly what you asked it to, but you asked it to do the wrong thing.
- Explain your code, line-by-line, to a friend or even a stuffed toy. Saying things out loud can help.
- Break up your code (a form of refactoring) into smaller and smaller sections, and confirm each section is working.
- Sometimes, it can help to take a walk and clear your mind.
