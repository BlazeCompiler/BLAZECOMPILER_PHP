
# Use official PHP image (7.4 FPM) as the base image
FROM php:7.4-fpm

# Install system dependencies and PHP extensions for gd, mbstring, and xml
RUN apt-get update \
    && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zlib1g-dev \
    libxml2-dev \
    libc-dev \
    gcc \
    make \
    pkg-config \
    libonig-dev \
    curl \
    && echo "Dependencies installed"

# Install Node.js and npm
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs \
    && echo "Node.js and npm installed"

# Install gd extension separately
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && echo "GD extension installed"

# Install mbstring extension separately
RUN docker-php-ext-install mbstring \
    && echo "Mbstring extension installed"

# Install xml extension separately
RUN docker-php-ext-install xml \
    && echo "XML extension installed"

# Set working directory
WORKDIR /app

# Copy all project files into the working directory in the container
COPY . .
# Copy custom PHP configuration
COPY php-custom.ini /usr/local/etc/php/conf.d/

# Install Node.js dependencies
RUN npm install && echo "npm install complete"

# Verify node_modules
RUN ls -l node_modules

# Expose the port your app will run on
EXPOSE 3000

RUN echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/docker-php-errors.ini
RUN echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php-errors.ini


# Start the server
CMD ["node", "server.js"]
# Command to run the app
CMD ["npm", "start"]
