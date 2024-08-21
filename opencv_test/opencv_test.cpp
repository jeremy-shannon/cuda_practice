
#include <opencv2/opencv.hpp>
#include <iostream>
#include "cuda_test.cuh"

using namespace cv;
using namespace std;

int main(int argc, char** argv)
{
    // Read the image file
    Mat image = imread("../img.png");

    // Check for failure
    if (image.empty()) 
    {
        cout << "Could not open or find the image" << endl;
        cin.get(); //wait for any key press
        return -1;
    }
    else {
        cout << "Image loaded!" << endl;    
    }

    //  String windowName = "The Guitar"; //Name of the window
    //  namedWindow(windowName); // Create a window

    imshow("window name", image); // (windowName, image); // Show our image inside the created window.

    cout << "here" << endl;

    wrapper();

    waitKey(0); // Wait for any keystroke in the window
    //  destroyWindow(windowName); //destroy the created window

    return 0;
}