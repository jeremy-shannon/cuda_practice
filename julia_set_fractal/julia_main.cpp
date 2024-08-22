#include "cpu_bitmap.h"
#include "julia.cuh"
#include <opencv2/opencv.hpp>
#include <iostream>
#include <memory>

#define WIDTH 1400
#define HEIGHT 1000

using namespace std;

int main (void) {
    CPUBitmap* bmp = generate_julia(WIDTH, HEIGHT);
    unsigned char* pixels = bmp->get_ptr();
    int imsize = bmp->image_size();

    cv::Mat img = cv::Mat(HEIGHT, WIDTH, CV_8UC3);

    cout << img.rows << ", " << img.cols << endl;

    for (int i = 0; i < imsize; i+=4) {
        cv::Vec3b color = {pixels[i], pixels[i+1], pixels[i+2]};
        // if (pixels[i] > 0) cout << int(pixels[i]) << ",";
        int pxl_idx = i/4;
        int pxl_x = pxl_idx%WIDTH;
        int pxl_y = pxl_idx/WIDTH;
        img.at<cv::Vec3b>(cv::Point(pxl_x,pxl_y)) = color;
    }

    cv::imshow("window name", img); 
    
    cv::waitKey(0); // Wait for any keystroke in the window

    delete bmp;
    return 0;
}
