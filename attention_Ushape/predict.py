import cv2
import numpy as np
import glob
import os
import matplotlib.pyplot as plt
import ntpath
import tensorflow as tf
from attention_ushape_net import AttentionBinarizationModel
from tensorflow.keras.models import load_model


i_s = 256
model = load_model('model.h5', custom_objects={'Activation': tf.keras.layers.Activation})

def testing_images():
    ext = ['jpg', 'bmp', 'png']

    for e in ext:
        for imfile in sorted(glob.glob('testing_noisy/*' + e)):
            img_array = cv2.imread((imfile))

            file_name = ntpath.split(imfile)[1]
            # print(file_name)

            h, w = img_array.shape[0], img_array.shape[1]
           # print(h,w)

            rem_row = np.mod(h, i_s)
            rem_col = np.mod(w, i_s)
         #   print(rem_row, rem_col)
            padding_row = i_s - rem_row
            padding_col = i_s - rem_col
            padding_row_mod = np.mod(padding_row,2)
            padding_col_mod = np.mod(padding_col,2)


            if padding_row_mod == 0:
                padding_row2_1 = padding_row // 2
                padding_row2_2 = padding_row // 2
            else:
                padding_row2_1 = round(padding_row // 2)
                padding_row2_2 = round(padding_row // 2) +1

            if padding_col_mod == 0:
                padding_col2_1 = padding_col // 2
                padding_col2_2 = padding_col // 2
            else:
                padding_col2_1 = round(padding_col // 2)
                padding_col2_2 = round(padding_col // 2) +1
           # print(padding_row2_1, padding_row2_2, padding_col2_1, padding_col2_2)

            new_img = np.pad(img_array, [[padding_row2_1, padding_row2_2], [padding_col2_1, padding_col2_2], [0, 0]],
                             mode='constant', constant_values=255)

            row2, col2 = new_img.shape[0], new_img.shape[1]
            bin_im = np.zeros((row2, col2))
           # print(row2,col2)

            step_1 = i_s

            # calculate binary image for every patch with 256 step

            for i in range(0, row2 - step_1 + 1, step_1):
                for j in range(0, col2 - step_1 + 1, step_1):
                    block = new_img[i:i + step_1, j:j + step_1, :]
                    predict = model.predict(block.reshape(-1, i_s, i_s, 3), verbose=0)
                    predict = (predict > 0.5).astype(np.uint8)

                    bin_im[i:i + step_1, j:j + step_1] = np.squeeze(predict)


            # keep border of calculated binary image and
            # recalculate the rest of image with 128 step

            step_2 = i_s//2
            start_end = i_s//4


            for i in range(start_end, row2 - step_1 - start_end + 1, step_2):
                for j in range(start_end, col2 - step_1 - start_end+ 1, step_2):
                    block = new_img[i:i + step_1, j:j + step_1, :]
                    predict = model.predict(block.reshape(-1, i_s, i_s, 3), verbose=0)
                    predict = (predict > 0.5).astype(np.uint8)
                    predict = np.squeeze(predict)

                    bin_im[i + start_end:i + step_1 - start_end, j + start_end:j + step_1 - start_end] = predict[start_end:step_1 - start_end, start_end:step_1- start_end]

            image_fin = bin_im[padding_row2_1:row2 -padding_row2_2, padding_col2_1:col2- padding_col2_2]
           # print(image_fin.shape)
            binary_file_name = 'binary_'+file_name
            cv2.imwrite(binary_file_name,255*image_fin)

            plt.figure(figsize=(10, 10))
            plt.imshow(image_fin, cmap='gray')
            plt.show()


if __name__ == '__main__':
    testing_images()