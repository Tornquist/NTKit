# NTKit

NTKit is a collection of custom UI elements built in Swift 2.  These elements are designed as a starting place for other applications.

# Contents

**Demo App:** All of the objects listed below are used in some way in the NTKitDemo app included in this project.  The demo app should also show a base implementation.

## NTTileView

The NTTileView is designed as a quick way to add a set of expanding tiles to your app.  To get started:

1. Add a NTTileView to your app.
2. Set the DataSource and implement the DataSource methods
3. Enjoy

![NTTileViewDemo](Screenshots/NTTileViewDemo.gif)

## NTImageView

NTImageView is a custom view designed to display an image and let the user zoom in and out.  To use:

1. Add a new UIView of type NTImageView
2. Set the image attribute (`[your view].image`)
3. Enjoy

To customize the default minimum and maximum zoom amounts, set the `defaultMinimumZoomScale` and `defaultMaximumZoomScale` values.

![NTImageViewDemo](Screenshots/NTImageViewDemo.gif)

## NTImage

NTImage replaces UIImage and allows for NTImageEffects to be applied to the base image.  NTImage can also be used anywhere that UIImage is used.  By default, this object will return the original image but `*.withEffects()` can be used to generate a UIImage will the effects applied.

### Effects

* **NTImageProgressCircle**: A circle filled in based on a provided percentage or start/end angles.  This object will draw a pie shape or an arc depending on the configuration used.
* **NTImageRectangleEffect**: This effect simply draws a colored rectangle at the coordinates provided.
* **NTImageShadeEffect**: This effect will draw over an entire image in the region provided (top, bottom, bottom right triangle, etc)
* **NTImageTextEffect**: This effect will draw text to the screen in the default font, or one provided.

# License

This project is completely open source and under the MIT license. For full details please see [license.md](LICENSE.md)