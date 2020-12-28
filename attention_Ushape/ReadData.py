class FlowData():

    """
    Class FlowData() could be used to load image dataset for a binary segmentation problem.

    Class call_method() could be used to apply augmentation methods to images.
    Augmentation options are the following:
    * normalization, flipping_right_left, flipping_up_down, bright(change image brightness),
      rotation(90rot image), contrast(change image contrast)

    There are two options in class FlowData() to load data to network. The first one is to read
    data from directory (noisy image and the corresponding binary image must be merged into one image).

    Example of reading image from directory using FlowData Class:
    --- define directory of training and validation sets, batch size and shuffling

    path_train = 'training_noisy_binary'
    path_valid = 'validation_noisy_binary'
    batch_size = 16
    shuffling = 15000
    --- call call_method() to define augmentation methods
    augm_data_train = FlowData.call_method(normalization=1/255., flipping_right_left=True, flipping_up_down=True,
                                 bright=0.2, rotation= True, contrast=(0.2,0.5))

    augm_data_valid = FlowData.call_method(normalization=1/255.)

    --- call network_dict() to define the training process
    dataset = FlowData.network_dict(path_train,batch_size=batch_size,shuffling=shuffling, augm_data=augm_data_train)
    valid = FlowData.network_dict(path_valid,batch_size=batch_size,shuffling=shuffling, augm_data=augm_data_valid)

    --- use get_data() to load data to network
    steps = 30000//batch_size
    val_steps = 6000//batch_size

    model.fit(dataset.get_data(),validation_data=valid.get_data(),
                    steps_per_epoch=steps,validation_steps=val_steps, epochs=100)


    Example of put images on matrices and then load to network using FlowData Class:
    --- define directory of training noisy data and binary data

    path_noisy  = 'training_data_noisy/'
    path_segm = 'training_data_binary/'
    batch_size = 16
    shuffling = 3000
    --- use call_method() to define augmentation method
    --- use load_to_ram() to read images
    augm_data_train = FlowData.call_method(normalization=1/255.,  flipping_up_down=True, bright=0.2)
    s = FlowData.load_to_ram(path_noisy=path_noisy, path_segm=path_segm)
    noisy, segm = s.load_data()

     dataset = FlowData.network_ram(noisy=noisy,segm=segm.reshape(-1,256,256,1),batch_size=batch_size,shuffling=shuffling, augm_data=augm_data)
     **then we can follow th same processing for validation dataset

     --- use get_data() to load data to network
     steps = 30000//batch_size
     val_steps = 6000//batch_size
     results = model.fit(dataset.get_data(), valid.get_data()
                    steps_per_epoch=steps,validation_steps=val_steps, epochs=100)

    """


    class augmentation():
        def __init__(self, augm_status):
            self.augm_status = np.asarray(augm_status)
            # print(self.augm_status)

        def isNaN(self, num):
            return num != num

        def apply_augm(self):

            def apply_augm(noisy, segm):

                def normalization(noisy, segm):
                    noisy = noisy * self.augm_status[0]
                    segm = segm * self.augm_status[0]
                    return noisy, tf.round(segm)

                def flipping_right_left(noisy, segm):
                    concat_images = tf.concat([noisy, segm], 2)
                    image = tf.image.random_flip_left_right(concat_images)
                    noisy = tf.slice(image, [0, 0, 0], [256, 256, 3])
                    segm = tf.slice(image, [0, 0, 3], [256, 256, 1])
                    return noisy, segm

                def flipping_up_down(noisy, segm):
                    concat_images = tf.concat([noisy, segm], 2)
                    image = tf.image.random_flip_up_down(concat_images)
                    noisy = tf.slice(image, [0, 0, 0], [256, 256, 3])
                    segm = tf.slice(image, [0, 0, 3], [256, 256, 1])
                    return noisy, segm

                def bright(noisy, segm):
                    noisy = tf.image.random_brightness(noisy, max_delta=self.augm_status[3])
                    return noisy, segm

                def rotation(noisy, segm):
                    way = tf.random.uniform(shape=[], minval=0, maxval=2, dtype=tf.int32)
                    #   way_ = random.choice([0,1,3])

                    noisy = tf.image.rot90(noisy, way)
                    segm = tf.image.rot90(segm, way)
                    return noisy, segm

                def contrast(noisy, segm):
                    (lower_, upper_) = self.augm_status[5]
                    noisy = tf.image.random_contrast(noisy, lower=lower_, upper=upper_)
                    return noisy, segm

                if self.augm_status[0] is not None:
                    noisy, segm = normalization(noisy, segm)
                if self.augm_status[1] is not None:
                    noisy, segm = flipping_right_left(noisy, segm)
                if self.augm_status[2] is not None:
                    noisy, segm = flipping_up_down(noisy, segm)
                if self.augm_status[3] is not None:
                    noisy, segm = bright(noisy, segm)
                if self.augm_status[4] is not None:
                    noisy, segm = rotation(noisy, segm)
                if self.augm_status[5] is not None:
                    noisy, segm = contrast(noisy, segm)
                return noisy, segm

            return apply_augm

    class call_method(augmentation):
        def __init__(self, normalization=None, flipping_right_left=None, flipping_up_down=None, bright=None,
                     rotation=None, contrast=None):
            self.augm_status = []
            self.augm_status = [normalization, flipping_right_left, flipping_up_down, bright, rotation, contrast]
            super().__init__(self.augm_status)

    class network_dict():

        def __init__(self, path_train, batch_size, shuffling, augm_data=None):
            self.path_train = path_train
            self.batch_size = batch_size
            self.shuffling = shuffling
            self.augm_data = augm_data

        def get_data(self):
            def load(image_file):
                image = tf.io.read_file(image_file)
                image = tf.image.decode_jpeg(image)
                image_div = (tf.shape(image)[1]) // 2

                noisy_data = image[:, :image_div, :]
                segm_data = image[:, image_div:, :]
                segm_data = tf.image.rgb_to_grayscale(segm_data)

                noisy_data = tf.cast(noisy_data, tf.float32)
                segm_data = tf.cast(segm_data, tf.float32)

                return noisy_data, segm_data

            def load_image_train(image_file):
                x_return, y_return = load(image_file)
                if self.augm_data is not None:
                    x_return, y_return = (self.augm_data).apply_augm()(x_return, y_return)

                return x_return, y_return

            dataset = tf.data.Dataset.list_files(self.path_train + '/*.jpg')
            dataset = dataset.map(load_image_train, num_parallel_calls=tf.data.experimental.AUTOTUNE)
            dataset = dataset.shuffle(self.shuffling)
            dataset = dataset.batch(self.batch_size).prefetch((self.batch_size) * 2).repeat()

            return dataset

    class load_to_ram():

        def __init__(self, path_noisy, path_segm):
            self.path_noisy = path_noisy
            self.path_segm = path_segm
            self.noisy_data = []
            self.segm_data = []
            self.training_idx = []

        def load_data(self):

            def create_noisy_data():

                ext = ['png', 'jpg', 'bmp']
                for e in ext:
                    for infile in sorted(glob.glob(self.path_noisy + '/*' + e)):
                        img_array = cv2.imread(infile)
                        (self.noisy_data).append(img_array)

                self.noisy_data = np.asarray(self.noisy_data)
                print((self.noisy_data).shape)
                self.training_idx = np.random.randint((self.noisy_data).shape[0], size=round(1 * len(self.noisy_data)))
                self.noisy_data = self.noisy_data[self.training_idx, :]
                return self.noisy_data

            def create_training_data():

                ext = ['png', 'jpg', 'bmp']
                for e in ext:
                    for infile in sorted(glob.glob(self.path_segm + '/*' + e)):
                        img_array = cv2.imread((infile), 0)
                        ret, bw_img = cv2.threshold(img_array, 127, 1, cv2.THRESH_BINARY)
                        self.segm_data.append(bw_img)

                self.segm_data = np.asarray(self.segm_data)
                self.segm_data = self.segm_data[self.training_idx, :]
                return self.segm_data

            return create_noisy_data(), create_training_data()

    class network_ram():

        def __init__(self, noisy, segm, batch_size, shuffling, augm_data=None):
            self.noisy = noisy
            self.segm = segm
            self.batch_size = batch_size
            self.shuffling = shuffling
            self.augm_data = augm_data

        def get_data(self):
            def load_dataset():
                images = tf.data.Dataset.from_tensor_slices((self.noisy, self.segm))
                images = images.map(map_func=augmentation).batch(self.batch_size).shuffle(self.shuffling).repeat()
                return images

            def augmentation(inp1, inp2):
                x_return = inp1
                y_return = inp2

                if self.augm_data is not None:
                    x_return, y_return = (augm_data).apply_augm()(x_return, y_return)

                return x_return, y_return

            return load_dataset()


