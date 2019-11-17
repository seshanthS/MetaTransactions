let webpack = require('webpack')
module.exports = {
    //target: 'node',

/*     node: {
        fs: 'empty',
        net: 'empty',
        tls: 'empty',
        global: true,
        crypto: "empty",
        process: true,
        module: false,
        clearImmediate: false,
        setImmediate: false
    }, */
    plugins: [new webpack.IgnorePlugin(/^electron$/)]
}