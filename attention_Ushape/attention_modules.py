class AttentionModules(tf.keras.layers.Layer):
    """
                               -- Attention Modules --
    'attention module' includes channel attention and spatial attention modules based on :

    This method uses decoder's feature map to weight skip encoder feature map.
    'attention module' takes as inputs encoder's and decoder's feature maps
    and the number of desired output channels.

    'self attention module' based on:

    This method is used to weight skip encoder feature map.
    'self attention module' takes as input skip encoder's feature map
    and the number of desire output channels

    """

    def __init__(self):
        super(AttentionModules, self).__init__()
        self.gamma = self.add_weight(shape=(),
                                     initializer=tf.initializers.Zeros,
                                     trainable=True)

    def attention_module(self, **params):
        filters = params["filters"]

        def attention_module(decoder, encoder):
            # channel attention module
            decoder_input = tf.keras.layers.GlobalAveragePooling2D()(decoder)
            decoder_input = tf.keras.layers.Reshape([1, 1, filters])(decoder_input)

            mlp_0 = tf.keras.layers.Dense(units=filters // 8, activation=tf.keras.layers.Activation(activation='relu'))(
                decoder_input)
            mlp_1 = tf.keras.layers.Dense(units=filters)
            avg_ = mlp_1(mlp_0)

            channel_output = tf.keras.layers.multiply([decoder_input, encoder])

            # spatial attention module
            avg_pool = tf.keras.layers.Lambda(lambda x: tf.math.reduce_mean(x, axis=[3], keepdims=True))(decoder)
            avg_pool = tf.keras.layers.Conv2D(filters=1, kernel_size=(3, 3), padding='same', use_bias=False)(avg_pool)
            avg_pool = tf.keras.activations.sigmoid(avg_pool)
            attention_output = tf.keras.layers.multiply([channel_output, avg_pool])

            return attention_output

        return attention_module

    def self_attention_module(self, **params):
        filters = params["filters"]
        kernel_size = params["kernel_size"]
        strides = params.setdefault("strides", (1, 1))
        padding = params.setdefault("padding", "same")
        kernel_initializer = params.setdefault("kernel_initializer", "he_normal")

        def self_attention_module(inputs):
            #   self.gamma = self.add_weight(self.name + 'gamma', shape=(), initializer=tf.initializers.Zeros)

            query = tf.keras.layers.Conv2D(filters=filters // 8, kernel_size=kernel_size, strides=strides,
                                           padding=padding, kernel_initializer=kernel_initializer)(inputs)
            key = tf.keras.layers.Conv2D(filters=filters // 8, kernel_size=kernel_size, strides=strides,
                                         padding=padding, kernel_initializer=kernel_initializer)(inputs)
            value = tf.keras.layers.Conv2D(filters=filters, kernel_size=kernel_size, strides=strides, padding=padding,
                                           kernel_initializer=kernel_initializer)(inputs)
            dims = tf.shape(value)
            batch_size = dims[0]
            height = dims[1]
            width = dims[2]
            channels = dims[3]

            proj_query = tf.reshape(query, [batch_size, height * width, channels // 8])
            proj_key = tf.transpose(tf.reshape(key, [batch_size, height * width, channels // 8]), (0, 2, 1))
            proj_value = tf.transpose(tf.reshape(value, [batch_size, height * width, filters]), (0, 2, 1))

            query_key_matmul = tf.matmul(proj_query, proj_key)
            attention_map = tf.keras.activations.softmax(query_key_matmul)
            proj_attention_map = tf.transpose(attention_map, (0, 2, 1))
            output = tf.matmul(proj_value, proj_attention_map)
            output = tf.reshape(tf.transpose(output, (0, 2, 1)), (batch_size, height, width, -1))
            attention_output = tf.add(tf.multiply(output, self.gamma), inputs)
            return attention_output

        return self_attention_module
