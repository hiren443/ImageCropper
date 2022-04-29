//
//  ImageCropViewController.swift
//  ImageCropper
//
//  Created by Hiren Bhadreshwara on 4/22/22.
//

import UIKit
import AVFoundation

class ImageCropViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var cropButton: UIButton!

    let dragView = DraggableView()
    let containerView = UIImageView()

    @IBOutlet weak var cropView: DraggableView! {
        didSet {
            cropView.layer.cornerRadius = 5
            cropView.layer.borderWidth = 3
            cropView.layer.borderColor = UIColor.cyan.cgColor
        }
    }
    @IBOutlet var imageView: UIImageView! {
        didSet {
            imageView.backgroundColor = UIColor.clear
        }
    }
    var selectedImage: UIImage? = nil


    var topConstraint: NSLayoutConstraint!
    var rightConstraint: NSLayoutConstraint!
    var leftConstraint: NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint!

    @IBOutlet var rect: UIView! {
        didSet {
            rect.layer.cornerRadius = 5
            rect.layer.borderWidth = 3
            rect.layer.borderColor = UIColor.cyan.cgColor
            rect.backgroundColor = UIColor.clear
        }
    }
    struct ResizeRect{
        var topTouch = false
        var leftTouch = false
        var rightTouch = false
        var bottomTouch = false
        var middelTouch = false
    }
    var touchStart = CGPoint.zero
    var touchCornerSize = CGFloat(10)
    var resizeRect = ResizeRect()
    var imageRect = CGRect()
    var hiddenView = UIView()

    @IBOutlet weak var resizableView: ResizableView! {
        didSet {
            resizableView.layer.cornerRadius = 5
            resizableView.layer.borderWidth = 3
            resizableView.layer.borderColor = UIColor.cyan.cgColor
            resizableView.backgroundColor = UIColor.clear
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.addDragView()
        self.addRectView()
    }


  /*  override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = selectedImage
        let dragView = DraggableView()
         dragView.backgroundColor = .cyan
         dragView.frame = CGRect(x: 20, y: 20, width: 50, height: 50)
        imageView.addSubview(dragView)
//        imageView.isUserInteractionEnabled = false
        cropView.isHidden = true
        var panGesture  = UIPanGestureRecognizer()
        //pan gesture for dragging an image
//        panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragImg(_:)))
        self.cropView.isUserInteractionEnabled = true
        self.cropView.addGestureRecognizer(panGesture)
        var pinchGesture  = UIPinchGestureRecognizer()
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(_:)))
        self.cropView.addGestureRecognizer(pinchGesture)

    }*/

    func addRectView() {
        cropView.isHidden = true
        imageView.image = selectedImage
//        rect.isHidden = false
        resizableView.isHidden = true
        self.imageRect = self.calculateRectOfImageInImageView(imageView: self.imageView)
        hiddenView = UIView(frame: self.calculateRectOfImageInImageView(imageView: self.imageView))
        hiddenView.translatesAutoresizingMaskIntoConstraints = false
        hiddenView.backgroundColor = .clear
        
        self.view.addSubview(hiddenView)
        let constraints = [
//            hiddenView.topAnchor.constraint(equalTo: self.imageView.topAnchor, constant: self.imageRect.origin.y - 20),
//            hiddenView.leftAnchor.constraint(equalTo: self.imageView.leftAnchor),
//            hiddenView.widthAnchor.constraint(equalToConstant: self.imageRect.size.width),
//            hiddenView.heightAnchor.constraint(equalToConstant: self.imageRect.size.height)
            hiddenView.topAnchor.constraint(equalTo: self.imageView.topAnchor, constant: self.imageRect.origin.y - 20),
            hiddenView.leftAnchor.constraint(equalTo: self.imageView.leftAnchor),
            hiddenView.widthAnchor.constraint(equalToConstant: self.imageRect.size.width),
            hiddenView.heightAnchor.constraint(equalToConstant: self.imageRect.size.height)

        ]
        NSLayoutConstraint.activate(constraints)

        rect = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        rect.translatesAutoresizingMaskIntoConstraints = false
        rect.backgroundColor = .clear
        hiddenView.addSubview(rect)

        self.leftConstraint = self.rect.leadingAnchor.constraint(equalTo: self.hiddenView.leadingAnchor)//X
        self.rightConstraint = self.rect.trailingAnchor.constraint(equalTo: self.hiddenView.trailingAnchor, constant: -150) //Width
        self.topConstraint = self.rect.topAnchor.constraint(equalTo: self.hiddenView.topAnchor) //Y
        self.bottomConstraint = self.rect.bottomAnchor.constraint(equalTo: self.hiddenView.bottomAnchor, constant: -150) //height

//        self.topConstraint = self.rect.topAnchor.constraint(equalTo: self.hiddenView.topAnchor, constant: 50) //Y
//        self.leftConstraint = self.rect.leftAnchor.constraint(equalTo: self.hiddenView.leftAnchor, constant: 50)//X
//        self.rightConstraint = self.rect.widthAnchor.constraint(equalTo: self.hiddenView.widthAnchor, constant: -150) //Width
//        self.bottomConstraint = self.rect.heightAnchor.constraint(equalTo: self.hiddenView.heightAnchor, constant: -150) //height

        self.rect.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([self.leftConstraint, self.rightConstraint, self.topConstraint, self.bottomConstraint])

    }

    func calculateRectOfImageInImageView(imageView: UIImageView) -> CGRect {
            let imageViewSize = imageView.frame.size
            let imgSize = imageView.image?.size

            guard let imageSize = imgSize else {
                return CGRect.zero
            }

            let scaleWidth = imageViewSize.width / imageSize.width
            let scaleHeight = imageViewSize.height / imageSize.height
            let aspect = fmin(scaleWidth, scaleHeight)

            var imageRect = CGRect(x: 0, y: 0, width: imageSize.width * aspect, height: imageSize.height * aspect)
            // Center image
            imageRect.origin.x = (imageViewSize.width - imageRect.size.width) / 2
            imageRect.origin.y = (imageViewSize.height - imageRect.size.height) / 2

            // Add imageView offset
            imageRect.origin.x += imageView.frame.origin.x
            imageRect.origin.y += imageView.frame.origin.y

            return imageRect
        }


    func addDragView() {
        cropView.isHidden = true
        //           let dragView = DraggableView()
        dragView.layer.cornerRadius = 5
        dragView.layer.borderWidth = 3
        dragView.layer.borderColor = UIColor.cyan.cgColor
        dragView.frame = CGRect(x: 20, y: 20, width: 250, height: 250)

        imageView.image = selectedImage
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let containerView = UIImageView()
        containerView.image = selectedImage
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .red

        let dragSuperView = UIView()
        dragSuperView.translatesAutoresizingMaskIntoConstraints = false
        dragSuperView.backgroundColor = .clear
        dragSuperView.addSubview(dragView)
//        containerView.addSubview(dragSuperView)

//        self.view.addSubview(containerView)
        self.view.addSubview(dragSuperView)
        let g = view.safeAreaLayoutGuide

//        NSLayoutConstraint.activate([
//            containerView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
//            containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor),
//            containerView.centerXAnchor.constraint(equalTo: g.centerXAnchor),
//            containerView.centerYAnchor.constraint(equalTo: g.centerYAnchor),
//        ])

        NSLayoutConstraint.activate([
            dragSuperView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
            dragSuperView.heightAnchor.constraint(equalTo: imageView.heightAnchor),
            dragSuperView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            dragSuperView.centerYAnchor.constraint(equalTo: g.centerYAnchor),
        ])

        var pinchGesture  = UIPinchGestureRecognizer()
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchRecognized(_:)))
        dragView.addGestureRecognizer(pinchGesture)
    }

    @objc func dragImg(_ sender:UIPanGestureRecognizer){
        let translation = sender.translation(in: self.view)
        self.cropView.center = CGPoint(x: self.cropView.center.x + translation.x, y: self.cropView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }

    @objc func didPinch(_ sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        let view = sender.view!
        let currentTransform = view.transform
        view.transform = view.transform.scaledBy(x: scale, y: scale)
        sender.scale = 1
    }

    @objc func pinchRecognized(_ pinch: UIPinchGestureRecognizer) {

        // unwrap the view from the gesture
        // AND
        // unwrap that view's superView
        guard let piece = pinch.view,
              let superV = piece.superview
        else {
            return
        }

        // this is a bit verbose for clarity

        // get the new scale
        let sc = pinch.scale

        // get current frame of "piece" view
        let currentPieceRect = piece.frame

        // apply scaling transform to the rect
        let futureRect = currentPieceRect.applying(CGAffineTransform(scaleX: sc, y: sc))

        // if the resulting rect's width will be
        //  greater-than-or-equal to superView's width
        if futureRect.width <= superV.bounds.width {
            // go ahead and scale the piece view
            piece.transform = piece.transform.scaledBy(x: sc, y: sc)
        }
        pinch.scale = 1

    }

    // MARK: - Actions
    @IBAction func buttonCropTapped(_ sender: Any) {
        guard let imageToCrop = imageView.image else {
            return
        }

        let cropRect = CGRect(x: (self.rect.frame.origin.x + self.imageRect.origin.x) - imageView.realImageRect().origin.x,
                              y: (self.rect.frame.origin.y + self.imageRect.origin.y) - imageView.realImageRect().origin.y,
                              width: self.rect.frame.width,
                              height: self.rect.frame.height)

        let croppedImage = self.cropImage(imageToCrop,
                                          toRect: cropRect,
                                          imageViewWidth: imageView.frame.width,
                                          imageViewHeight: imageView.frame.height)
        self.imageView.backgroundColor = UIColor.clear
        self.imageView.image = croppedImage
        self.dragView.isHidden = true
        self.rect.isHidden = true
        cropButton.isHidden = true
    }

    func cropImage(_ inputImage: UIImage, toRect cropRect: CGRect, imageViewWidth: CGFloat, imageViewHeight: CGFloat) -> UIImage?
    {
        let imageViewScale = max(inputImage.size.width / imageViewWidth,
                                 inputImage.size.height / imageViewHeight)

        // Scale cropRect to handle images larger than shown-on-screen size
        let cropZone = CGRect(x: cropRect.origin.x * imageViewScale,
                              y: cropRect.origin.y * imageViewScale,
                              width: cropRect.size.width * imageViewScale,
                              height: cropRect.size.height * imageViewScale)

        // Perform cropping in Core Graphics
        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to: cropZone)
            else {
                return nil
        }

        // Return image to UIImage
        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        return croppedImage
    }

   /* override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
        let position = touch.location(in: cropView.superview)

        var x:CGFloat = position.x
        var y:CGFloat = position.y

        let parentWidth = imageView.superview?.frame.size.width
        let parentHeight = imageView.superview?.frame.size.height

        let width = cropView.frame.size.width / 2
        let height = cropView.frame.size.height / 2

        x = max(width, x)
        x = min(x, parentWidth ?? 0.0 - width)

        y = max(height, y)
        y = min(y, parentHeight ?? 0.0 - height)

        cropView.center = CGPoint(x: x, y: y)

    }
    }
*/
}

// MARK: - UIScrollViewDelegate
extension ImageCropViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

extension UIImageView {

    // MARK: - Methods
    func realImageRect() -> CGRect {
        let imageViewSize = self.frame.size
        let imgSize = self.image?.size

        guard let imageSize = imgSize else {
            return CGRect.zero
        }

        let scaleWidth = imageViewSize.width / imageSize.width
        let scaleHeight = imageViewSize.height / imageSize.height
        let aspect = fmin(scaleWidth, scaleHeight)

        var imageRect = CGRect(x: 0, y: 0, width: imageSize.width * aspect, height: imageSize.height * aspect)

        // Center image
        imageRect.origin.x = (imageViewSize.width - imageRect.size.width) / 2
        imageRect.origin.y = (imageViewSize.height - imageRect.size.height) / 2

        // Add imageView offset
        imageRect.origin.x += self.frame.origin.x
        imageRect.origin.y += self.frame.origin.y

        return imageRect
    }
}

class DraggableView: UIView {

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        // unwrap superview and touch
        guard let sv = superview,
            let touch = touches.first
        else { return }

        let parentFrame = sv.bounds

        let location = touch.location(in: self)
        let previousLocation = touch.previousLocation(in: self)

        // new frame for this "draggable" subview, based on touch offset when moving
        var newFrame = self.frame.offsetBy(dx: location.x - previousLocation.x, dy: location.y - previousLocation.y)

        // make sure Left edge is not past Left edge of superview
        newFrame.origin.x = max(newFrame.origin.x, 0.0)
        // make sure Right edge is not past Right edge of superview
        newFrame.origin.x = min(newFrame.origin.x, parentFrame.size.width - newFrame.size.width)

        // make sure Top edge is not past Top edge of superview
        newFrame.origin.y = max(newFrame.origin.y, 0.0)
        // make sure Bottom edge is not past Bottom edge of superview
        newFrame.origin.y = min(newFrame.origin.y, parentFrame.size.height - newFrame.size.height)

        self.frame = newFrame

    }

}

extension ImageCropViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{

            let touchStart = touch.location(in: self.hiddenView)
            print(touchStart)

            resizeRect.topTouch = false
            resizeRect.leftTouch = false
            resizeRect.rightTouch = false
            resizeRect.bottomTouch = false
            resizeRect.middelTouch = false

            if  touchStart.y > rect.frame.minY + (touchCornerSize*2) &&
                    touchStart.y < rect.frame.maxY - (touchCornerSize*2) &&
                    touchStart.x > rect.frame.minX + (touchCornerSize*2) &&
                    touchStart.x < rect.frame.maxX - (touchCornerSize*2){
                resizeRect.middelTouch = true
                print("middle")
                return
            }

            if touchStart.y > rect.frame.maxY - touchCornerSize &&  touchStart.y < rect.frame.maxY + touchCornerSize {
                resizeRect.bottomTouch = true
                print("bottom")
            }

            if touchStart.x > rect.frame.maxX - touchCornerSize && touchStart.x < rect.frame.maxX + touchCornerSize {
                resizeRect.rightTouch = true
                print("right")
            }

            if touchStart.x > rect.frame.minX - touchCornerSize &&  touchStart.x < rect.frame.minX + touchCornerSize {
                resizeRect.leftTouch = true
                print("left")
            }

            if touchStart.y > rect.frame.minY - touchCornerSize &&  touchStart.y < rect.frame.minY + touchCornerSize {
                resizeRect.topTouch = true
                print("top")
            }

        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let currentTouchPoint = touch.location(in: hiddenView)
            let previousTouchPoint = touch.previousLocation(in: hiddenView)

//            if currentTouchPoint.y < 1 || currentTouchPoint.y > self.hiddenView.frame.size.height {
//                return
//            }
//
//            if currentTouchPoint.x < 1 || currentTouchPoint.x > self.hiddenView.frame.size.width {
//                return
//            }

            let deltaX = currentTouchPoint.x - previousTouchPoint.x
            let deltaY = currentTouchPoint.y - previousTouchPoint.y
                        print("currentTouchPoint \(currentTouchPoint)")
                        print("previousTouchPoint \(previousTouchPoint)")

            print("Width \(rect.frame.size.width)")
            print("Height \(rect.frame.size.height)")
            print("deltaX \(deltaX)")
            print("deltaY \(deltaY)")
            if resizeRect.middelTouch {
                print("**  Middle Touch")
//               topConstraint.constant += deltaY
//               leftConstraint.constant += deltaX
//               rightConstraint.constant += deltaX
//               bottomConstraint.constant += deltaY
               if topConstraint.constant + deltaY > 0
                    && leftConstraint.constant + deltaX > 0
                    && rightConstraint.constant + deltaX < -25
                    && bottomConstraint.constant + deltaY < -touchCornerSize {
                   print("**  Middle Touch CHANGE VALUE")
                   topConstraint.constant += deltaY
                   leftConstraint.constant += deltaX
                   rightConstraint.constant += deltaX
                   bottomConstraint.constant += deltaY
               }
            }

            if resizeRect.topTouch {
                print("**  Top Touch")
                if rect.frame.size.height > 80 || deltaY < 0 {
                    topConstraint.constant += deltaY
                }
            }

            if resizeRect.leftTouch {
                print("**  Left Touch")
                if rect.frame.size.width > 80 || deltaX < 0 {
                    leftConstraint.constant += deltaX
                }
            }
            if resizeRect.rightTouch {
                print("**  Right Touch")
                if rect.frame.size.width > 80 || deltaX > 0 {
                    rightConstraint.constant += deltaX
                }
            }
            if resizeRect.bottomTouch {
                print("**  Bottom Touch")
                if rect.frame.size.height > 80 || deltaY > 0 {
                    bottomConstraint.constant += deltaY
                }
            }

            UIView.animate(withDuration: 0.15, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                       self.view.layoutIfNeeded()
                   }, completion: { (ended) in

                   })
        }
    }
}
