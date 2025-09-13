# RedSpace Roku Test

A Roku application written in BrightScript.

## Getting Started

### Prerequisites

- Node.js and npm
- Visual Studio Code
- BrightScript Language extension for VS Code
- Roku device in developer mode

### Installation

1. Clone the repository:
```bash
git clone git@github.com:jamesjordan/redspace-roku-test.git
cd redspace-roku-test
```

2. Install dependencies:
```bash
npm install
```

3. Create a `.env` file in the root directory with your Roku device details:
```
ROKU_DEV_TARGET=<your-roku-ip-address>
ROKU_DEVPASSWORD=<your-roku-dev-password>
```

### Running the Application

#### Debug from VS Code

1. Open the project in Visual Studio Code
2. Ensure the BrightScript Language extension is installed
3. Press `F5` or go to Run > Start Debugging
4. The app will be deployed to your Roku device and debugging session will start

### Project Structure

- `/components` - SceneGraph components
- `/source` - BrightScript source files
- `/images` - Image assets
- `/fonts` - Font files
- `/data` - Configuration and data files
- `manifest` - Roku app manifest file