// Computer Vision Bootcamp: a fully interactive course. Lesson bodies live in ./lessons/*.md,
// checkpoint quizzes in ./quizzes/*.json. Validate with: node seed/courses/validate.mjs computer-vision-bootcamp
export const course = {
  slug: "computer-vision-bootcamp",
  title: "Computer Vision Bootcamp",
  subtitle: "Pixels, convolutions, detection, segmentation and vision transformers, built in NumPy and taught the way production systems work.",
  category: "computer-vision",
  instructor: "sofia",
  level: "intermediate",
  price: 0,
  compareAt: null,
  accent: 24,
  featured: false,
  students: 24310,
  tags: ["CNNs", "Object Detection", "Segmentation", "ViT"],
  learn: [
    "Read images as arrays and apply augmentations that keep labels correct",
    "Compute convolution output sizes, receptive fields and parameter counts",
    "Transfer a pretrained backbone with a frozen-feature linear probe",
    "Measure detections with IoU and non-maximum suppression, and decode anchor boxes",
    "Evaluate segmentation with per-class IoU, and explain U-Net skip connections and Dice loss",
    "Use patch embeddings and CLIP-style zero-shot classification, and evaluate a detector",
  ],
  requirements: [
    "Python and NumPy. The browser runs the NumPy code; PyTorch and torchvision code is shown for local use",
    "Some deep-learning background helps, such as Deep Learning Foundations",
  ],
  audience: [
    "Engineers building vision features who want to understand what the models compute",
    "Robotics and imaging practitioners who need detection or segmentation",
    "Data scientists moving from tabular data into images",
  ],
  description: `Computer vision turns pixels into decisions: what is in this picture, where it is, and which pixels belong to it. This bootcamp teaches the ideas behind those answers. Each one is implemented in NumPy so the arithmetic is visible, and then the same idea is shown in the PyTorch and torchvision code used in production.

## Learn by building

- **Every operation in NumPy.** Convolutions, output sizes, receptive fields, IoU, non-maximum suppression, anchor decoding, patch embeddings and Dice loss all run in the page.
- **Metrics that matter.** You compute per-class IoU, precision and recall at an IoU threshold, and average precision, the numbers used to compare detectors in papers.
- **Debug challenges.** You fix the bugs that quietly break vision code: a forgotten padding term, a receptive-field calculation in the wrong order, uint8 overflow during augmentation, and a skip connection concatenated on the wrong axis.
- **Framework code, shown honestly.** Full detectors, U-Nets and CLIP models are static PyTorch code for you to run locally, and each is paired with a NumPy version of the idea it uses.

## What you'll cover

- **Images as data:** pixels, channels, convolutions and augmentation.
- **Classification:** CNN architectures, parameter counts and transfer learning.
- **Detection:** boxes, IoU and NMS, anchors, one-stage and two-stage detectors, and training targets.
- **Segmentation:** semantic and instance masks, pixel IoU, U-Net and Dice loss.
- **Vision transformers:** patch embeddings, CLIP and zero-shot classification, and a capstone evaluation.

## Why this course?

Many vision tutorials start with a framework call that trains a model and stop there. When a detector drops boxes or a segmenter fails on small objects, you need to know what the metric measures, what each shape means and where a bug can hide. This course gives you that understanding before the framework does the rest.`,
};

// Links attached to the first lesson.
export const resources = [
  { title: "Faster R-CNN: Towards Real-Time Object Detection (Ren et al.)", url: "https://arxiv.org/abs/1506.01497" },
  { title: "U-Net: Convolutional Networks for Biomedical Image Segmentation", url: "https://arxiv.org/abs/1505.04597" },
  { title: "An Image is Worth 16x16 Words: Vision Transformers", url: "https://arxiv.org/abs/2010.11929" },
  { title: "Learning Transferable Visual Models From Natural Language Supervision (CLIP)", url: "https://arxiv.org/abs/2103.00020" },
];

const lesson = (file, title, minutes, extra = {}) => ({ file, title, minutes, ...extra });
const quiz = (file, title) => ({ quiz: file, title });

export const sections = [
  {
    title: "Images as Data",
    lessons: [
      lesson("01-welcome.md", "How this course works", 8, { preview: true }),
      lesson("02-pixels-channels.md", "Pixels, channels and colour spaces", 14),
      lesson("03-convolution.md", "Convolution: sliding a filter over an image", 18),
      lesson("04-augmentation.md", "Augmentation that keeps labels correct", 14),
    ],
  },
  {
    title: "Classification",
    lessons: [
      lesson("05-cnn-architectures.md", "CNN architectures, parameters and receptive fields", 18),
      lesson("06-transfer-learning.md", "Transfer learning and the linear probe", 16),
      quiz("s1.json", "Checkpoint: classification"),
    ],
  },
  {
    title: "Detection",
    lessons: [
      lesson("07-boxes-iou-nms.md", "Bounding boxes, IoU and non-maximum suppression", 16),
      lesson("08-anchors-one-vs-two-stage.md", "Anchors and one-stage versus two-stage detectors", 18),
      lesson("09-training-detector.md", "Training a detector: targets and losses", 18),
      quiz("s2.json", "Checkpoint: detection"),
    ],
  },
  {
    title: "Segmentation",
    lessons: [
      lesson("10-semantic-instance.md", "Semantic and instance segmentation", 14),
      lesson("11-unet.md", "U-Net: encoders, decoders and skip connections", 20),
      quiz("s3.json", "Checkpoint: segmentation"),
    ],
  },
  {
    title: "Vision Transformers",
    lessons: [
      lesson("12-vit-patches.md", "Vision transformers: patches and positions", 16),
      lesson("13-clip-zero-shot.md", "CLIP and zero-shot classification", 16),
      lesson("14-capstone-evaluation.md", "Capstone: evaluating a detector", 24),
      quiz("s4.json", "Final assessment: Computer Vision Bootcamp"),
    ],
  },
];
