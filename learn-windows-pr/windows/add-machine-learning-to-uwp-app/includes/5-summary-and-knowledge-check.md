Congratulations, you have taken the first step toward incorporating a machine learning model into your UWP app. You should now have a better understanding of why you may want to run model evaluations locally on your Windows 10 device vs running evaluations in the cloud. 

We reviewed the basics of where to find or create a machine learning model, exporting the model to the correct format (or using WinMLTools to convert it if necessary), loading the model in Visual Studio, binding the inputs and outputs in your UWP app, and using the model to evaluate your input (a Windows Ink drawing in our example). 

## Related Courses

We encourage you to keep learning. More courses will be coming soon, in the meantime, consider these related courses on how to build your own machine learning models.

- [Classify images with the Microsoft Custom Vision Service](https://docs.microsoft.com/learn/modules/classify-images-with-custom-vision-service/)
- [Process images with the Computer Vision service](https://docs.microsoft.com/learn/modules/create-computer-vision-service-to-classify-images/index)

## Additional Resources

**Windows Machine Learning**
- [Windows Machine Learning API reference](https://docs.microsoft.com/en-us/windows/ai/api-reference)
- [Windows Machine Learning Docs]( https://docs.microsoft.com/windows/ai/)
- [WinMLTools](https://docs.microsoft.com/windows/ai/convert-model-winmltools): Convert models trained in other ML frameworks into ONNX format for use with the Windows ML API.

## APIs referenced in this course
- [`StorageFile`](https://docs.microsoft.com/uwp/api/windows.storage.storagefile.getfilefromapplicationuriasync#remarks)
- [`ImageFeatureValue`](https://docs.microsoft.com/uwp/api/windows.ai.machinelearning.imagefeaturevalue)
- [`VideoFrame`](https://docs.microsoft.com/uwp/api/windows.media.videoframe)
- [`GetAsVectorView`](https://docs.microsoft.com/uwp/api/windows.ai.machinelearning.tensorfloat.getasvectorview)
- [`InkPresenter`](https://docs.microsoft.com/en-us/uwp/api/windows.ui.input.inking.inkpresenter)
- [`CoreInputDeviceTypes`](https://docs.microsoft.com/en-us/uwp/api/windows.ui.core.coreinputdevicetypes)

**Other Machine Learning Resources at Microsoft** 
- [Compare ML products at Microsoft](https://docs.microsoft.com/en-us/azure/machine-learning/service/overview-more-machine-learning)
- [Azure Cognitive Services](https://azure.microsoft.com/en-us/services/cognitive-services/): Find pre-built models to train with Vision, Speech, Knowledge, Search, or Language AI.
- [Azure Custom Vision Service](https://docs.microsoft.com/azure/cognitive-services/custom-vision-service/getting-started-build-a-classifier): Customize your own computer vision models for your unique use case by simply uploading and labeling images. 
- [Azure Machine Learning](https://azure.microsoft.com/overview/machine-learning/): Build, train, deploy, and manage your own models.
- [Visual Studio Tools for AI](https://visualstudio.microsoft.com/downloads/ai-tools-vs/): An extension that supports deep learning frameworks including Microsoft Cognitive Toolkit (CNTK), Google TensorFlow, Theano, Keras, Caffe2 and more. 

**ONNX Model Resources**
- [ONNX Model Zoo](https://github.com/onnx/models): Download pre-trained ONNX models, like the MNIST model we used for this course.
- [ONNX tutorials](https://github.com/onnx/tutorials): How to import and export ONNX models between other ML frameworks. 
