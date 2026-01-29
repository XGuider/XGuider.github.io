const path = require('path')
const TerserPlugin = require('terser-webpack-plugin')
const { InjectManifest } = require('workbox-webpack-plugin')

module.exports = (env, argv) => {
  const isProduction = argv.mode === 'production'

  return {
    entry: {
      main: './js/src/main.js'
    },
    plugins: [
      new InjectManifest({
        swSrc: './js/src/sw-workbox.js',
        swDest: 'sw.bundle.js',
        exclude: [/\.map$/, /manifest$/, /\.htaccess$/]
      })
    ],
    output: {
      path: path.resolve(__dirname, 'js'),
      filename: '[name].bundle.js',
      clean: {
        keep: /src\//
      }
    },
    module: {
      rules: [
        {
          test: /\.js$/,
          exclude: /node_modules/,
          use: {
            loader: 'babel-loader',
            options: {
              presets: ['@babel/preset-env']
            }
          }
        }
      ]
    },
    optimization: {
      minimize: isProduction,
      minimizer: [
        new TerserPlugin({
          terserOptions: {
            format: {
              comments: false,
            },
          },
          extractComments: false,
        })
      ],
      splitChunks: {
        chunks: 'all',
        cacheGroups: {
          vendor: {
            test: /[\\/]node_modules[\\/]/,
            name: 'vendors',
            chunks: 'all',
          }
        }
      }
    },
    devtool: isProduction ? false : 'source-map',
    resolve: {
      extensions: ['.js']
    }
  }
}