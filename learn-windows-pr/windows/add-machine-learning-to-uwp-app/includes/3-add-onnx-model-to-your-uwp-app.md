> [!VIDEO https://www.microsoft.com/en-us/videoplayer/embed/RE2Mcxn]

The next step toward incorporating machine learning into your UWP app is to add the Windows ML API to our UWP app resources in the `MainPage.xaml.cs` file. The API can be added with the `using` directive.

```
using Windows.AI.MachineLearning;
```

This Windows ML API enables apps to load machine learning models, bind features, and evaluate the results. You can find the Windows ML API Reference page linked at the end of this course.

## Download a pre-trained model

We can now load a pre-trained machine learning model into our app. Windows ML evaluates models using the Open Neural Network Exchange (ONNX) format. ONNX is an open format for ML models, allowing you to interchange models between various frameworks and tools. 

There are several ways to get an ONNX model to use with Windows ML on a Windows 10 device. You can:

- Download a pre-trained ONNX model from the **ONNX Model Zoo**.
- Train your own model with a service, such as **Azure Cognitive Services** for pre-built models that you can train with Vision, Speech, Knowledge, Search, or Language AI; with the **Azure Machine Learning Service** to train, deploy, and manage your own models; or with **Visual Studio Tools for AI**, an extension that supports deep learning frameworks including Microsoft Cognitive Toolkit (CNTK), Google TensorFlow, Theano, Keras, Caffe2 and more. 
- Convert models trained in other ML frameworks into ONNX format with **WinMLTools** or using the **ONNX model format tutorials**.

For the purposes of this course, we have already downloaded the MNIST - Handwritten Digit Recognition model from the ONNX Model Zoo to use with our app. This model predicts handwritten digits using a convolutional neural network. We've only applied a relatively simple level of training to the model, giving it the ability to identify handwritten numbers 1 - 9 with a reasonable level of confidence and accuracy. 

## Add the ONNX model to your UWP project

The `mnist.onnx` model file can be found in the **Assets** folder of your project. To add it to your UWP project in Visual Studio, do the following.

:::row:::
    :::column:::
        Right-click on the **MNIST_Demo (Universal Windows)** folder in the **Solution Explorer**, and select **Add** > **Existing Item**. 
        
        Point the file picker to the location of the **mnist.onnx** model, and click **Add**.
        
        Visual Studio will add the ONNX model in addition to auto-generating a CS file:
        - `mnist.onnx` - your pre-trained model.
        - `mnist.cs` - the Windows ML auto-generated code.

        The auto-generated `mnist.cs` file contains three classes:
        - **mnistModel** creates the machine learning model representation, establishes a session on the system default device, binds the specific inputs and outputs to the model, and evaluates the model asynchronously. 
        - **mnistInput** initializes the input types that the model expects. In this case, the input expects an [ImageFeatureValue](https://docs.microsoft.com/uwp/api/windows.ai.machinelearning.imagefeaturevalue).
        - **mnistOutput** initializes the types that the model will output. In this case, the output will be a list called `Plus214_Output_0` of type [TensorFloat](https://docs.microsoft.com/uwp/api/windows.ai.machinelearning.tensorfloat).

        Right-click on the **mnist.onnx** model (in the Assets folder) and select "Properties." In the Properties window, check to ensure that the **"Build Action"** is set to **"Content"**. This setting allows you to retrieve a file as a stream via `Application.GetContentStream(URI)`. For this method to work, it needs a `AssemblyAssociatedContentFile` custom attribute which Visual Studio graciously adds when you mark the file as "Content."
    :::column-end:::
    :::column:::
        ![Solution explorer with new ONNX model files](../media/MNIST_onnx_model_files.png)
    :::column-end:::
:::row-end:::

We can now use the auto-generated classes in the `mnist.cs` file to load, bind, and evaluate the model in our project.
