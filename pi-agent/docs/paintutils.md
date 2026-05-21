# PaintUtils API Reference

`paintutils` provides utilities for drawing graphics, shapes, and images on the current terminal or a redirected terminal object.

## Basic Drawing

- `paintutils.drawPixel(x, y, [color])`: Draws a single pixel at `{x, y}`. If `color` is omitted, the current background color is used.
- `paintutils.drawLine(x1, y1, x2, y2, [color])`: Draws a straight line between two points.
- `paintutils.drawBox(x1, y1, x2, y2, [color])`: Draws the outline of a rectangle.
- `paintutils.drawFilledBox(x1, y1, x2, y2, [color])`: Draws a solid filled rectangle.

## Image Management

- `paintutils.parseImage(imageString)`: Parses an image from a multi-line string.
- `paintutils.loadImage(path)`: Loads an image file (usually `.nfp`) from the filesystem.
- `paintutils.drawImage(image, x, y)`: Draws a previously parsed/loaded image starting at `{x, y}`.

## Important Notes

Functions in this API may alter the current **cursor position** and **background color**. Always restore these if they need to be preserved for subsequent operations.
