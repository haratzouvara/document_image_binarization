import tensorflow as tf
from attention_modules import AttentionModules

class AttentionBinarizationModel(tf.keras.layers.Layer):
    """
                            -- Attention Binarization Model --
    The attention Binarization Model is a U-shape architecture based on U-net model.
    We can include an attention mechanism to model.


    """



    def residual_block(self, **params):
        filters = params["filters"]
        kernel_size = params["kernel_size"]
        strides = params.setdefault("strides", (1, 1))
        padding = params.setdefault("padding", "same")
        kernel_initializer = params.setdefault("kernel_initializer", "he_normal")

        def residual_block(input):
            x = tf.keras.layers.Conv2D(filters=filters, kernel_size=kernel_size, strides=strides, padding=padding,
                                       kernel_initializer=kernel_initializer)(input)
            x = tf.keras.layers.BatchNormalization(axis=3)(x)
            x = tf.keras.activations.relu(x)
            x = tf.keras.layers.Conv2D(filters=filters, kernel_size=kernel_size, strides=strides, padding=padding,
                                       kernel_initializer=kernel_initializer)(x)

            shortcut = tf.keras.layers.Conv2D(filters=filters, kernel_size=1, strides=strides, padding=padding,
                                              kernel_initializer=kernel_initializer)(input)

            out = tf.keras.layers.add([x, shortcut])
            out = tf.keras.layers.BatchNormalization(axis=3)(out)
            out = tf.keras.activations.relu(out)
            return out

        return residual_block

    def conv_block(self, **params):
        filters = params["filters"]
        kernel_size = params["kernel_size"]
        strides = params.setdefault("strides", (1, 1))
        padding = params.setdefault("padding", "same")
        kernel_initializer = params.setdefault("kernel_initializer", "he_normal")
        dropout_parameter = params.setdefault("dropout_parameter", None)

        def conv_block(input):
            x = tf.keras.layers.Conv2D(filters=filters, kernel_size=kernel_size, strides=strides, padding=padding,
                                       kernel_initializer=kernel_initializer)(input)
            x = tf.keras.layers.BatchNormalization(axis=3)(x)
            x = tf.keras.activations.relu(x)
            if dropout_parameter is not None:
                x = tf.keras.layers.Dropout(dropout_parameter)(x)
            return x

        return conv_block

    def encoder_decoder(self, **att_params):
        attention_fun = att_params.setdefault("attention_fun", None)

        inputs = tf.keras.layers.Input((None, None, 3))
        conv1 = self.conv_block(filters=16, kernel_size=(1, 1), dropout_parameter=0.2)(inputs)
        pool1 = tf.keras.layers.AveragePooling2D((2, 2), padding="same")(conv1)

        conv2 = self.residual_block(filters=32, kernel_size=(3, 3))(pool1)
        conv2 = self.conv_block(filters=32, kernel_size=(3, 3), dropout_parameter=0.2)(conv2)
        pool2 = tf.keras.layers.AveragePooling2D((2, 2), padding='same')(conv2)

        conv3 = self.residual_block(filters=64, kernel_size=(3, 3))(pool2)
        conv3 = self.conv_block(filters=64, kernel_size=(3, 3), dropout_parameter=0.3)(conv3)
        pool3 = tf.keras.layers.AveragePooling2D((2, 2), padding='same')(conv3)

        conv4 = self.residual_block(filters=128, kernel_size=(3, 3))(pool3)
        conv4 = self.conv_block(filters=128, kernel_size=(3, 3))(conv4)
        pool4 = tf.keras.layers.AveragePooling2D((2, 2), padding='same')(conv4)

        conv5 = self.conv_block(filters=256, kernel_size=(3, 3))(pool4)
        conv5 = self.conv_block(filters=256, kernel_size=(3, 3), dropout_parameter=0.4)(conv5)

        up1 = tf.keras.layers.UpSampling2D((2, 2))(conv5)
        up1 = self.residual_block(filters=128, kernel_size=(3, 3))(up1)
        if attention_fun == 'attention_module':
            att1 = AttentionModules().attention_module(filters=128, ratio=8)(up1, conv4)
        elif attention_fun == 'self_attention_module':
            att1 = AttentionModules().self_attention_module(filters=128, ratio=8)(conv4)
        else:
            att1 = conv4
        merge1 = tf.keras.layers.concatenate([att1, up1], axis=3)
        merge1 = self.conv_block(filters=128, kernel_size=(3, 3))(merge1)
        merge1 = self.conv_block(filters=128, kernel_size=(3, 3), dropout_parameter=0.3)(merge1)

        up2 = tf.keras.layers.UpSampling2D((2, 2))(merge1)
        up2 = self.residual_block(filters=64, kernel_size=(3, 3))(up2)
        if attention_fun == 'attention_module':
            att2 = AttentionModules().attention_module(filters=64, ratio=8)(up2, conv3)
        elif attention_fun == 'self_attention_module':
            att2 = AttentionModules().self_attention_module(filters=64, ratio=8)(conv3)
        else:
            att2 = conv3
        merge2 = tf.keras.layers.concatenate([att2, up2], axis=3)
        merge2 = self.conv_block(filters=64, kernel_size=(3, 3))(merge2)
        merge2 = self.conv_block(filters=64, kernel_size=(3, 3), dropout_parameter=0.3)(merge2)

        up3 = tf.keras.layers.UpSampling2D((2, 2))(merge2)
        up3 = self.residual_block(filters=32, kernel_size=(3, 3))(up3)
        if attention_fun == 'attention_module':
            att3 = AttentionModules().attention_module(filters=32, ratio=8)(up3, conv2)
        elif attention_fun == 'self_attention_module':
            att3 = AttentionModules().self_attention_module(filters=32, ratio=8)(conv2)
        else:
            att3 = conv2
        merge3 = tf.keras.layers.concatenate([att3, up3], axis=3)
        merge3 = self.conv_block(filters=32, kernel_size=(3, 3))(merge3)
        merge3 = self.conv_block(filters=32, kernel_size=(3, 3), dropout_parameter=0.2)(merge3)

        up4 = tf.keras.layers.UpSampling2D((2, 2))(merge3)
        up4 = self.residual_block(filters=16, kernel_size=(3, 3))(up4)
        if attention_fun == 'attention_module':
            att4 = AttentionModules().attention_module(filters=16, ratio=8)(up4, conv1)
        elif attention_fun == 'self_attention_module':
            att4 = AttentionModules().self_attention_module(filters=16, ratio=8)(conv1)
        else:
            att4 = conv1
        merge4 = tf.keras.layers.concatenate([att4, up4], axis=3)
        merge4 = self.conv_block(filters=16, kernel_size=(3, 3))(merge4)
        merge4 = self.conv_block(filters=16, kernel_size=(3, 3), dropout_parameter=0.2)(merge4)

        outputs = tf.keras.layers.Conv2D(filters=1, kernel_size=(1, 1))(merge4)
        outputs = tf.keras.activations.sigmoid(outputs)
        model = tf.keras.Model(inputs=[inputs], outputs=[outputs])
        return model



