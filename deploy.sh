#!/bin/bash

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
    echo -e "${BLUE}==== $1 ====${NC}"
}

# Function to detect docker compose command
get_docker_compose_cmd() {
    if command -v docker compose &> /dev/null; then
        echo "docker compose"
    elif docker compose version &> /dev/null; then
        echo "docker compose"
    else
        print_error "Please install Docker and Docker Compose"
        exit 1
    fi
}

# Main deployment function (single .env version)
deploy() {
    print_header "STARTING DEPLOYMENT"
    
    local DOCKER_COMPOSE_CMD=$(get_docker_compose_cmd)
    
    print_status "Using command: $DOCKER_COMPOSE_CMD"
    print_status "Building and starting all services..."
    if $DOCKER_COMPOSE_CMD up --build -d; then
        print_status "Services started successfully!"
    else
        print_error "Failed to start services"
        exit 1
    fi
    
    print_status "Waiting for services to be ready..."
    sleep 10
    
    print_status "Checking services status..."
    $DOCKER_COMPOSE_CMD ps
    
    print_header "DEPLOYMENT COMPLETED"
    print_status "Frontend: http://localhost:3001"
    print_status "API Backend 1: http://localhost/api/backend1"
    print_status "API Backend 2: http://localhost/api/backend2"
    print_status "Nginx Status: http://localhost:8080/nginx_status"
    print_status "Health Check: http://localhost/health"
}

# Check logs function
check_logs() {
    print_header "CHECKING LOGS"
    local DOCKER_COMPOSE_CMD=$(get_docker_compose_cmd)
    
    echo "Available services:"
    $DOCKER_COMPOSE_CMD ps --format "table {{.Name}}\t{{.Status}}"
    echo ""
    echo "To check specific service logs:"
    echo "$DOCKER_COMPOSE_CMD logs -f [service_name]"
    echo ""
    echo "Following all logs..."
    $DOCKER_COMPOSE_CMD logs -f
}

# Stop services function
stop_services() {
    print_header "STOPPING SERVICES"
    local DOCKER_COMPOSE_CMD=$(get_docker_compose_cmd)
    
    print_status "Stopping all services..."
    $DOCKER_COMPOSE_CMD down
    print_status "Services stopped successfully!"
}

# Clean up function
cleanup() {
    print_header "CLEANING UP"
    local DOCKER_COMPOSE_CMD=$(get_docker_compose_cmd)
    
    print_warning "This will remove all containers, networks, and images!"
    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Cleaning up..."
        $DOCKER_COMPOSE_CMD down --rmi all -v
        print_status "Cleanup completed!"
    else
        print_status "Cleanup cancelled."
    fi
}

# Health check function
health_check() {
    print_header "PERFORMING HEALTH CHECK"
    
    print_status "Checking nginx health..."
    if curl -s http://localhost/health > /dev/null; then
        print_status "✓ Nginx health check passed"
    else
        print_error "✗ Nginx health check failed"
    fi
    
    print_status "Checking frontend..."
    if curl -s http://localhost:3001 > /dev/null; then
        print_status "✓ Frontend is responding"
    else
        print_error "✗ Frontend is not responding"
    fi
    
    print_status "Checking nginx status..."
    if curl -s http://localhost:8080/nginx_status > /dev/null; then
        print_status "✓ Nginx status page is available"
    else
        print_warning "✗ Nginx status page is not available"
    fi
}

# Show help
show_help() {
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  start              Start all services (default)"
    echo "  logs               Show logs for all services"
    echo "  stop               Stop all services"
    echo "  restart            Restart all services"
    echo "  clean              Clean up (remove containers, networks, images)"
    echo "  health             Perform health check"
    echo "  status             Show services status"
    echo "  help               Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                 # Start services (default)"
    echo "  $0 start           # Start services"
    echo "  $0 logs            # Show logs"
    echo "  $0 stop            # Stop services"
    echo "  $0 restart         # Restart services"
    echo "  $0 clean           # Clean up everything"
}

# Restart function
restart_services() {
    print_header "RESTARTING SERVICES"
    local DOCKER_COMPOSE_CMD=$(get_docker_compose_cmd)
    
    print_status "Stopping services..."
    $DOCKER_COMPOSE_CMD down
    print_status "Starting services..."
    deploy
}

# Status function
show_status() {
    print_header "SERVICES STATUS"
    local DOCKER_COMPOSE_CMD=$(get_docker_compose_cmd)
    
    $DOCKER_COMPOSE_CMD ps
}

# Main script logic
case "${1:-start}" in
    "start"|"")
        deploy
        ;;
    "logs")
        check_logs
        ;;
    "stop")
        stop_services
        ;;
    "restart")
        restart_services
        ;;
    "clean")
        cleanup
        ;;
    "health")
        health_check
        ;;
    "status")
        show_status
        ;;
    "help"|"-h"|"--help")
        show_help
        ;;
    *)
        print_error "Unknown option: $1"
        show_help
        exit 1
        ;;
esac
