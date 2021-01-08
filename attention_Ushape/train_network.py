import tensorflow as tf
from ReadData import FlowData
from attention_ushape_net import AttentionBinarizationModel
import os


# -- define dataset folder

""" -- noisy images and ground truth images in separate folder -- """

path_noisy_train = 'training_data_noisy/'
path_segm_train = 'training_data_binary/'
path_noisy_valid = 'validation_data_noisy/'
path_segm_valid = 'validation_data_binary/'

list = os.listdir(path_noisy_train)
train_files = len(list)

list = os.listdir(path_noisy_valid)
valid_files = len(list)

"""  --  noisy images and ground truth images joined on the axis of width -- """
#path_noisy_segm_train = 'training_noisy_binary'
#path_noisy_segm_valid = 'validation_noisy_binary'

#list = os.listdir(path_noisy_segm_train)   # number of image files
#train_files = len(list)

#list = os.listdir(path_noisy_segm_train)
#valid_files = len(list)



# -- for noisy images and ground truth images
#path_noisy = 'validation_data_noisy_paper2/'

# -- define network architecture
# -- attention_fun could be 'attention_module', 'self_attention_module' or you could to not use one
model = AttentionBinarizationModel().encoder_decoder(attention_fun='attention_module')
#model.summary()

# -- define network hyperparameters
op= tf.keras.optimizers.Adam(learning_rate= 0.0003)
model.compile(optimizer= op, loss='binary_crossentropy', metrics=['accuracy'])

batch_size = 4
shuffling = 10

# -- define augmentation methods to be used
augm_data = FlowData.call_method(normalization=1/255., bright=0.2, contrast=(1.0, 1.5))

"""
 -------     USAGE OF LOAD TO RAM IMAGES METHOD ---------

"""
# -- load images to ram
ram_train = FlowData.load_to_ram(path_noisy=path_noisy_train, path_segm=path_segm_train)
ram_valid = FlowData.load_to_ram(path_noisy=path_noisy_valid, path_segm=path_segm_valid)
noisy_train, segm_train = ram_train.load_data()
noisy_valid, segm_valid = ram_valid.load_data()

image_x = tf.shape(noisy_train)[1]
image_y = tf.shape(noisy_train)[2]


# -- load images to network
dataset = FlowData.network_ram(noisy=noisy_train, segm=segm_train.reshape(-1,image_x,image_y,1),batch_size=batch_size,shuffling=shuffling, augm_data=augm_data)
valid = FlowData.network_ram(noisy=noisy_valid, segm=segm_valid.reshape(-1,image_x,image_y,1),batch_size=batch_size,shuffling=shuffling, augm_data=augm_data)



"""
 -------     USAGE OF READ IMAGES FROM DIRECTORIES METHOD ---------

"""
# -- read images from directories

#dataset = FlowData.network_dict(path_noisy_segm=path_noisy_segm_train,batch_size=batch_size,shuffling=shuffling, augm_data=augm_data)
#valid = FlowData.network_dict(path_noisy_segm=path_noisy_segm_valid,batch_size=batch_size,shuffling=shuffling, augm_data=augm_data)


# -- define training steps and validation steps
steps = train_files//batch_size
val_steps = valid_files//batch_size

# train network
results = model.fit(dataset.get_data(), validation_data= valid.get_data(),
                    steps_per_epoch=steps,validation_steps=val_steps, epochs=100)


