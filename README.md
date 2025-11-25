# Image Processor

A Rails 8 web application for uploading and analyzing images with detailed histogram and color statistics. This app extracts RGB channel data, calculates statistical metrics, and visualizes histogram data for uploaded images.

## Features

- **Image Upload**: Upload images in common formats (JPEG, PNG, etc.)
- **Histogram Analysis**: Extract and analyze RGB channel histograms
- **Color Statistics**: Calculate mean, standard deviation, min, max, and median for each color channel
- **Image Properties**: Detect image colorspace, bits per channel, and bits per pixel
- **Color Analysis**: Determine dominant color and overall brightness/contrast metrics
- **Visualization**: Display histogram data using interactive charts
- **Image Storage**: Store images with AWS S3 integration support

## Tech Stack

- **Ruby**: 3.3+
- **Rails**: 8.1.1
- **Database**: SQLite3 (configurable)
- **Web Server**: Puma
- **Asset Pipeline**: Propshaft
- **Frontend Framework**: Hotwire (Turbo + Stimulus)
- **Image Processing**: MiniMagick, ImageProcessing
- **Data Analysis**: DescriptiveStatistics
- **Charting**: Chartkick
- **Form Builder**: SimpleForm
- **Storage**: Active Storage with AWS S3 support

## System Dependencies

- Ruby 3.3.0 or higher
- ImageMagick or GraphicsMagick (for MiniMagick)
- Git

On Ubuntu/Debian:
```bash
sudo apt-get install imagemagick libmagickwand-dev
```

On macOS:
```bash
brew install imagemagick
```

## Setup Instructions

### 1. Clone the Repository

```bash
git clone <repository-url>
cd image_processor
```

### 2. Install Dependencies

```bash
bundle install
```

### 3. Database Setup

```bash
rails db:create
rails db:migrate
```

### 4. Start the Development Server

```bash
./bin/dev
```

The application will be available at `http://localhost:3000`

## Project Structure

```
app/
├── controllers/
│   ├── images_controller.rb    # Handles image CRUD operations
│   └── application_controller.rb
├── models/                      # Active Record models
├── views/                       # ERB templates
└── helpers/                     # View helpers

lib/
└── historygram.rb              # Image analysis engine

config/
├── routes.rb                   # Route definitions
├── database.yml                # Database configuration
└── environments/               # Environment-specific configs

storage/                        # Local storage for uploaded files
```

## Usage

### Uploading an Image

1. Navigate to the home page (`/images`)
2. Click "New Image"
3. Select an image file from your computer
4. Click "Create"

The app will:
- Process the image with MiniMagick
- Extract RGB channel data
- Calculate statistical metrics (mean, std, min, max, median)
- Generate histograms for each channel
- Save the image and analysis results

### Viewing Results

The image show page displays:
- **RGB Channel Statistics**: Mean, standard deviation, min, max, and median values
- **Image Properties**: Bits per channel, bits per pixel, colorspace
- **General Metrics**: Overall brightness and contrast
- **Dominant Color**: RGB values of the most prevalent color
- **Histograms**: Interactive charts showing channel distributions

## API Endpoints

- `GET /images` - List all images
- `POST /images` - Create new image and process histogram
- `GET /images/:id` - View image details and analysis
- `PATCH /images/:id` - Update image metadata
- `DELETE /images/:id` - Delete image

## Configuration

### Environment Variables

Create a `.env` file in the root directory (optional):

```env
DATABASE_URL=sqlite3:db/development.sqlite3
RAILS_SERVE_STATIC_FILES=true
```

### AWS S3 Storage (Optional)

To use AWS S3 instead of local storage, configure in `config/storage.yml` and set:

```bash
RAILS_STORAGE_SERVICE=amazon
AWS_ACCESS_KEY_ID=your_key
AWS_SECRET_ACCESS_KEY=your_secret
AWS_BUCKET=your_bucket
AWS_REGION=us-east-1
```

## Testing

Run the full test suite:

```bash
rails test
```

Run specific tests:

```bash
rails test test/controllers/images_controller_test.rb
rails test test/models/image_test.rb
```

Run system tests:

```bash
rails test:system
```

## Security Checks

Run security audits:

```bash
# Check gems for vulnerabilities
./bin/bundler-audit

# Static analysis for security issues
./bin/brakeman
```

## Code Quality

Run RuboCop for code style:

```bash
./bin/rubocop
```

## Docker

Build and run with Docker:

```bash
docker-compose up -d
```

The application will be available at `http://localhost:3000`

## Services

- **Cache**: SolidCache (database-backed)
- **Job Queue**: SolidQueue (database-backed)
- **WebSockets**: SolidCable (database-backed)
- **Image Storage**: Active Storage with local/S3 support

## Deployment

Deploy using Kamal (Docker-based deployment):

```bash
kamal deploy
```

For other deployment options, see `config/deploy.yml`

## Development Tools

- **Web Console**: Available in development mode at `/console`
- **Thruster**: HTTP asset caching and X-Sendfile acceleration
- **Bundler Audit**: Security audits for gems
- **Brakeman**: Static security analysis
- **RuboCop**: Code style enforcement

## Troubleshooting

### Images not processing
- Ensure ImageMagick is installed: `convert -version`
- Check image format is supported (JPEG, PNG, GIF, etc.)

### Database locked errors
- Delete `db/development.sqlite3` and run `rails db:create db:migrate`

### Port already in use
- Change port: `./bin/dev -p 3001`

## Contributing

1. Create a feature branch (`git checkout -b feature/amazing-feature`)
2. Commit your changes (`git commit -m 'Add amazing feature'`)
3. Push to the branch (`git push origin feature/amazing-feature`)
4. Open a Pull Request

## License

This project is part of a technical drawing course assignment.

## Support

For issues or questions, please open an issue in the repository.
