#!/bin/bash

# Development helper script for techx-genai-platform

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  setup     - Build all development containers"
    echo "  start     - Start development environment"
    echo "  stop      - Stop development environment"
    echo "  restart   - Restart development environment"
    echo "  logs      - Show logs from all services"
    echo "  logs [service] - Show logs from specific service"
    echo "  shell [service] - Open shell in specific service"
    echo "  status    - Show status of all services"
    echo "  clean     - Clean up development environment"
    echo "  help      - Show this help message"
    echo ""
    echo "Services: frontend, backend, inference, ingestion, postgres"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker first."
        exit 1
    fi
}

# Function to setup development environment
setup_dev() {
    print_header "Setting up development environment"
    check_docker
    
    print_status "Building development containers..."
    docker compose -f docker-compose.dev.yaml build
    
    print_status "Development environment setup complete!"
    print_status "Run './dev.sh start' to start the services"
}

# Function to start development environment
start_dev() {
    print_header "Starting development environment"
    check_docker
    
    print_status "Starting services..."
    docker compose -f docker-compose.dev.yaml up -d
    
    print_status "Development environment started!"
    print_status "Services available at:"
    echo "  - Frontend: http://localhost:3000"
    echo "  - Backend: http://localhost:8000"
    echo "  - Inference: http://localhost:8030"
    echo "  - Ingestion: http://localhost:8060"
    echo "  - Chatbot: http://localhost:5173"
    echo "  - PostgreSQL: localhost:5432"
}

# Function to stop development environment
stop_dev() {
    print_header "Stopping development environment"
    
    print_status "Stopping services..."
    docker compose -f docker-compose.dev.yaml down
    
    print_status "Development environment stopped!"
}

# Function to restart development environment
restart_dev() {
    print_header "Restarting development environment"
    
    stop_dev
    sleep 2
    start_dev
}

# Function to show logs
show_logs() {
    if [ -z "$1" ]; then
        print_header "Showing logs from all services"
        docker compose -f docker-compose.dev.yaml logs -f
    else
        print_header "Showing logs from $1 service"
        docker compose -f docker-compose.dev.yaml logs -f "$1"
    fi
}

# Function to open shell in service
open_shell() {
    if [ -z "$1" ]; then
        print_error "Please specify a service name"
        echo "Available services: frontend, backend, inference, ingestion, postgres"
        exit 1
    fi
    
    print_header "Opening shell in $1 service"
    docker compose -f docker-compose.dev.yaml exec "$1" /bin/bash
}

# Function to show status
show_status() {
    print_header "Service Status"
    docker compose -f docker-compose.dev.yaml ps
}

# Function to clean up
clean_dev() {
    print_header "Cleaning up development environment"
    
    print_warning "This will remove all containers, volumes, and images for development"
    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Stopping and removing containers..."
        docker compose -f docker-compose.dev.yaml down -v
        
        print_status "Removing development images..."
        docker rmi $(docker images -q | grep techx-genai-platform) 2>/dev/null || true
        
        print_status "Cleanup complete!"
    else
        print_status "Cleanup cancelled"
    fi
}

# Main script logic
case "$1" in
    setup)
        setup_dev
        ;;
    start)
        start_dev
        ;;
    stop)
        stop_dev
        ;;
    restart)
        restart_dev
        ;;
    logs)
        show_logs "$2"
        ;;
    shell)
        open_shell "$2"
        ;;
    status)
        show_status
        ;;
    clean)
        clean_dev
        ;;
    help|--help|-h)
        show_usage
        ;;
    *)
        print_error "Unknown command: $1"
        echo ""
        show_usage
        exit 1
        ;;
esac
