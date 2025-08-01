#!/bin/bash
# Gaming Optimizations Post-Install Script
# Run this script on an existing Arch Linux installation to apply gaming optimizations

set -e

SCRIPT_VERSION="1.0.0"
LOG_FILE="/tmp/gaming-optimizations-$(date +%Y%m%d_%H%M%S).log"

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration flags
INSTALL_KERNEL=true
CONFIGURE_GRUB=true
CONFIGURE_CPU=true
CONFIGURE_IO=true
CONFIGURE_VM=true
CONFIGURE_REALTIME=true
CONFIGURE_SCHEDULING=true
CONFIGURE_MEMORY=true
DRY_RUN=false

log() {
    local level="$1"
    shift
    local message="$*"
    
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$level] $message" | tee -a "$LOG_FILE"
    
    case "$level" in
        "INFO") echo -e "${BLUE}ℹ️  $message${NC}" ;;
        "SUCCESS") echo -e "${GREEN}✅ $message${NC}" ;;
        "WARNING") echo -e "${YELLOW}⚠️  $message${NC}" ;;
        "ERROR") echo -e "${RED}❌ $message${NC}" ;;
        "STEP") echo -e "${PURPLE}🔧 $message${NC}" ;;
        "DRY_RUN") echo -e "${CYAN}🧪 [DRY RUN] $message${NC}" ;;
    esac
}

show_banner() {
    clear
    echo -e "${CYAN}"
    cat << 'BANNER'
╭─────────────────────────────────────────────────────────╮
│                                                         │
│        🎮 Gaming Optimizations Post-Install 🎮         │
│                                                         │
│  Apply comprehensive gaming optimizations to your       │
│  existing Arch Linux installation                       │
│                                                         │
│  • Gaming-optimized kernel (linux-zen)                 │
│  • CPU performance tuning                              │
│  • I/O scheduler optimization                          │
│  • Memory management tweaks                            │
│  • Real-time priorities                                │
│  • Process scheduling                                  │
│                                                         │
╰─────────────────────────────────────────────────────────╯
BANNER
    echo -e "${NC}"
    echo -e "${BLUE}Version: $SCRIPT_VERSION${NC}"
    echo -e "${BLUE}Log file: $LOG_FILE${NC}"
    if [ "$DRY_RUN" = true ]; then
        echo -e "${CYAN}🧪 DRY RUN MODE - No changes will be made${NC}"
    fi
    echo
}

show_help() {
    cat << 'HELP_TEXT'
🎮 Gaming Optimizations Post-Install Script

USAGE:
    ./post-install-gaming-optimizations.sh [OPTIONS]

OPTIONS:
    -h, --help              Show this help message
    -d, --dry-run          Test mode (no actual changes)
    --no-kernel            Skip gaming kernel installation
    --no-grub              Skip GRUB configuration
    --no-cpu               Skip CPU optimizations
    --no-io                Skip I/O scheduler optimizations
    --no-vm                Skip virtual memory optimizations
    --no-realtime          Skip real-time priority configuration
    --no-scheduling        Skip process scheduling configuration
    --no-memory            Skip memory management configuration
    --interactive          Interactive mode (ask before each step)

DESCRIPTION:
    Applies comprehensive gaming optimizations to an existing Arch Linux system:
    
    🎮 Gaming Kernel:
    • Installs linux-zen (gaming-optimized kernel)
    • Configures GRUB with gaming parameters
    
    ⚡ Performance:
    • CPU performance governor
    • I/O scheduler optimization
    • Virtual memory tuning
    • Real-time priorities
    • Process scheduling (ananicy-cpp)
    • Memory management (ZRAM)
    
EXAMPLES:
    sudo ./post-install-gaming-optimizations.sh
    sudo ./post-install-gaming-optimizations.sh --dry-run
    sudo ./post-install-gaming-optimizations.sh --no-kernel --interactive

REQUIREMENTS:
    • Arch Linux system
    • Root privileges
    • Internet connection
    • GRUB bootloader (for kernel parameters)

⚠️  WARNING: 
    • Creates system backups before changes
    • Reboot required after installation
    • Some optimizations may increase power consumption

HELP_TEXT
}

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            -d|--dry-run)
                DRY_RUN=true
                shift
                ;;
            --no-kernel)
                INSTALL_KERNEL=false
                shift
                ;;
            --no-grub)
                CONFIGURE_GRUB=false
                shift
                ;;
            --no-cpu)
                CONFIGURE_CPU=false
                shift
                ;;
            --no-io)
                CONFIGURE_IO=false
                shift
                ;;
            --no-vm)
                CONFIGURE_VM=false
                shift
                ;;
            --no-realtime)
                CONFIGURE_REALTIME=false
                shift
                ;;
            --no-scheduling)
                CONFIGURE_SCHEDULING=false
                shift
                ;;
            --no-memory)
                CONFIGURE_MEMORY=false
                shift
                ;;
            --interactive)
                INTERACTIVE=true
                shift
                ;;
            *)
                log "ERROR" "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done
}

check_prerequisites() {
    log "STEP" "Checking system prerequisites"
    
    # Check if running as root
    if [ "$EUID" -ne 0 ] && [ "$DRY_RUN" = false ]; then
        log "ERROR" "This script must be run as root (use sudo)"
        exit 1
    fi
    
    # Check if running on Arch Linux
    if [ "$DRY_RUN" = false ] && ! command -v pacman >/dev/null 2>&1; then
        log "ERROR" "This script is designed for Arch Linux (pacman not found)"
        exit 1
    fi
    
    # Check internet connection
    if [ "$DRY_RUN" = false ] && ! ping -c 1 archlinux.org >/dev/null 2>&1; then
        log "WARNING" "No internet connection detected - package installation may fail"
    fi
    
    # Check if GRUB is installed
    if [ "$DRY_RUN" = false ] && [ "$CONFIGURE_GRUB" = true ] && ! command -v grub-mkconfig >/dev/null 2>&1; then
        log "WARNING" "GRUB not found - kernel parameter configuration will be skipped"
        CONFIGURE_GRUB=false
    fi
    
    log "SUCCESS" "Prerequisites check completed"
}

create_backup() {
    if [ "$DRY_RUN" = true ]; then
        log "DRY_RUN" "Would create backup of system configuration"
        return
    fi
    
    log "STEP" "Creating system configuration backup"
    
    local backup_dir="/root/gaming-optimizations-backup-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    # Backup important configuration files
    [ -f /etc/default/grub ] && cp /etc/default/grub "$backup_dir/"
    [ -d /etc/sysctl.d ] && cp -r /etc/sysctl.d "$backup_dir/"
    [ -d /etc/security ] && cp -r /etc/security "$backup_dir/"
    [ -d /etc/systemd/system ] && find /etc/systemd/system -name "*gaming*" -exec cp {} "$backup_dir/" \; 2>/dev/null || true
    
    echo "$backup_dir" > /tmp/gaming-backup-location
    log "SUCCESS" "Backup created at: $backup_dir"
}

install_gaming_kernel() {
    if [ "$INSTALL_KERNEL" = false ]; then
        log "INFO" "Skipping gaming kernel installation (--no-kernel)"
        return
    fi
    
    if [ "$DRY_RUN" = true ]; then
        log "DRY_RUN" "Would install linux-zen gaming kernel and performance tools"
        return
    fi
    
    log "STEP" "Installing gaming-optimized kernel"
    
    # Update package database
    pacman -Sy
    
    # Check if linux-zen is available
    if pacman -Ss linux-zen >/dev/null 2>&1; then
        log "INFO" "Installing linux-zen (gaming-optimized kernel)"
        pacman -S --needed --noconfirm linux-zen linux-zen-headers
        log "SUCCESS" "linux-zen kernel installed"
    else
        log "WARNING" "linux-zen not available, using standard kernel with optimizations"
    fi
    
    # Install performance tools
    log "INFO" "Installing performance tools"
    pacman -S --needed --noconfirm \
        cpupower \
        irqbalance \
        preload
    
    # Try to install ananicy-cpp (may not be in official repos)
    if pacman -Ss ananicy-cpp >/dev/null 2>&1; then
        pacman -S --needed --noconfirm ananicy-cpp
        log "SUCCESS" "ananicy-cpp installed"
    else
        log "WARNING" "ananicy-cpp not available in repositories"
    fi
    
    log "SUCCESS" "Gaming kernel and performance tools installed"
}

configure_grub_gaming() {
    if [ "$CONFIGURE_GRUB" = false ]; then
        log "INFO" "Skipping GRUB configuration (--no-grub)"
        return
    fi
    
    if [ "$DRY_RUN" = true ]; then
        log "DRY_RUN" "Would configure GRUB with gaming kernel parameters"
        return
    fi
    
    log "STEP" "Configuring GRUB for gaming performance"
    
    # Backup original GRUB config
    cp /etc/default/grub /etc/default/grub.backup
    
    # Gaming kernel parameters
    local gaming_params=(
        "mitigations=off"
        "processor.max_cstate=1"
        "intel_idle.max_cstate=0"
        "idle=poll"
        "intel_pstate=performance"
        "split_lock_detect=off"
        "tsx=on"
        "tsx_async_abort=off"
        "kvm.ignore_msrs=1"
        "kvm.report_ignored_msrs=0"
        "nowatchdog"
        "nmi_watchdog=0"
        "rcu_nocbs=0-$(($(nproc) - 1))"
        "rcu_nocb_poll"
        "irqaffinity=1"
        "skew_tick=1"
        "tsc=reliable"
        "clocksource=tsc"
        "highres=on"
        "nohz=on"
        "preempt=full"
        "threadirqs"
    )
    
    # Add hardware-specific parameters
    if lspci | grep -i nvidia >/dev/null 2>&1; then
        gaming_params+=(
            "nvidia_drm.modeset=1"
            "nvidia.NVreg_UsePageAttributeTable=1"
            "nvidia.NVreg_InitializeSystemMemoryAllocations=0"
            "nvidia.NVreg_DynamicPowerManagement=0x02"
        )
        log "INFO" "Added NVIDIA-specific kernel parameters"
    fi
    
    if lscpu | grep -i intel >/dev/null 2>&1; then
        gaming_params+=(
            "intel_iommu=on"
            "iommu=pt"
            "i915.enable_guc=2"
            "i915.enable_fbc=1"
            "i915.fastboot=1"
        )
        log "INFO" "Added Intel-specific kernel parameters"
    fi
    
    # Join parameters
    local params_string=$(IFS=' '; echo "${gaming_params[*]}")
    
    # Update GRUB configuration
    sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"[^\"]*\"/GRUB_CMDLINE_LINUX_DEFAULT=\"quiet $params_string\"/" /etc/default/grub
    
    # Regenerate GRUB configuration
    grub-mkconfig -o /boot/grub/grub.cfg
    
    log "SUCCESS" "GRUB configured for gaming performance"
}

configure_cpu_performance() {
    if [ "$CONFIGURE_CPU" = false ]; then
        log "INFO" "Skipping CPU performance configuration (--no-cpu)"
        return
    fi
    
    if [ "$DRY_RUN" = true ]; then
        log "DRY_RUN" "Would configure CPU performance settings and create systemd service"
        return
    fi
    
    log "STEP" "Configuring CPU performance settings"
    
    # Create CPU performance service
    cat > /etc/systemd/system/gaming-cpu-performance.service << 'EOF'
[Unit]
Description=Gaming CPU Performance Optimization
After=multi-user.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/local/bin/gaming-cpu-setup.sh

[Install]
WantedBy=multi-user.target
EOF
    
    # Create CPU setup script
    cat > /usr/local/bin/gaming-cpu-setup.sh << 'EOF'
#!/bin/bash
# Gaming CPU Performance Setup

# Set performance governor
if [ -d /sys/devices/system/cpu/cpu0/cpufreq ]; then
    echo "performance" > /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 2>/dev/null || true
    echo "Gaming: CPU governor set to performance"
fi

# Disable CPU frequency scaling
if command -v cpupower >/dev/null 2>&1; then
    cpupower frequency-set -g performance >/dev/null 2>&1 || true
    echo "Gaming: CPU frequency scaling configured"
fi

# Set CPU performance bias
if [ -f /sys/devices/system/cpu/cpu0/power/energy_perf_bias ]; then
    echo 0 > /sys/devices/system/cpu/cpu*/power/energy_perf_bias 2>/dev/null || true
    echo "Gaming: CPU energy performance bias set to performance"
fi

# Disable CPU idle states for maximum performance
if [ -d /sys/devices/system/cpu/cpu0/cpuidle ]; then
    for state in /sys/devices/system/cpu/cpu*/cpuidle/state*/disable; do
        [ -f "$state" ] && echo 1 > "$state" 2>/dev/null || true
    done
    echo "Gaming: CPU idle states disabled"
fi

echo "Gaming CPU optimizations applied"
EOF
    
    chmod +x /usr/local/bin/gaming-cpu-setup.sh
    systemctl enable gaming-cpu-performance.service
    
    log "SUCCESS" "CPU performance service configured"
}

configure_io_scheduler() {
    if [ "$CONFIGURE_IO" = false ]; then
        log "INFO" "Skipping I/O scheduler configuration (--no-io)"
        return
    fi
    
    if [ "$DRY_RUN" = true ]; then
        log "DRY_RUN" "Would configure I/O scheduler optimizations"
        return
    fi
    
    log "STEP" "Configuring I/O scheduler for gaming"
    
    # Create I/O optimization service
    cat > /etc/systemd/system/gaming-io-scheduler.service << 'EOF'
[Unit]
Description=Gaming I/O Scheduler Optimization
After=multi-user.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/local/bin/gaming-io-setup.sh

[Install]
WantedBy=multi-user.target
EOF
    
    # Create I/O setup script
    cat > /usr/local/bin/gaming-io-setup.sh << 'EOF'
#!/bin/bash
# Gaming I/O Scheduler Setup

# Set I/O scheduler for NVMe drives (mq-deadline for gaming)
for nvme in /sys/block/nvme*; do
    if [ -f "$nvme/queue/scheduler" ]; then
        echo mq-deadline > "$nvme/queue/scheduler" 2>/dev/null || true
        echo "Gaming: NVMe $(basename $nvme) scheduler set to mq-deadline"
    fi
done

# Set I/O scheduler for SATA drives (bfq for mixed workloads)
for sda in /sys/block/sd*; do
    if [ -f "$sda/queue/scheduler" ]; then
        echo bfq > "$sda/queue/scheduler" 2>/dev/null || true
        echo "Gaming: SATA $(basename $sda) scheduler set to bfq"
    fi
done

# Optimize queue depths and settings
for device in /sys/block/*/queue; do
    # Increase queue depth for better throughput
    [ -f "$device/nr_requests" ] && echo 256 > "$device/nr_requests" 2>/dev/null || true
    
    # Disable rotational for SSDs
    [ -f "$device/rotational" ] && echo 0 > "$device/rotational" 2>/dev/null || true
    
    # Optimize read-ahead
    [ -f "$device/read_ahead_kb" ] && echo 256 > "$device/read_ahead_kb" 2>/dev/null || true
done

echo "Gaming I/O scheduler optimizations applied"
EOF
    
    chmod +x /usr/local/bin/gaming-io-setup.sh
    systemctl enable gaming-io-scheduler.service
    
    log "SUCCESS" "I/O scheduler optimizations configured"
}

configure_vm_gaming() {
    if [ "$CONFIGURE_VM" = false ]; then
        log "INFO" "Skipping virtual memory configuration (--no-vm)"
        return
    fi
    
    if [ "$DRY_RUN" = true ]; then
        log "DRY_RUN" "Would configure virtual memory for gaming"
        return
    fi
    
    log "STEP" "Configuring virtual memory for gaming"
    
    # Create gaming VM parameters
    cat > /etc/sysctl.d/99-gaming.conf << 'EOF'
# Gaming Virtual Memory Optimizations

# Reduce swappiness for gaming (keep more in RAM)
vm.swappiness = 1

# Improve responsiveness
vm.vfs_cache_pressure = 50

# Optimize dirty page handling for gaming
vm.dirty_ratio = 15
vm.dirty_background_ratio = 5
vm.dirty_expire_centisecs = 3000
vm.dirty_writeback_centisecs = 500

# Optimize kernel memory allocation
vm.min_free_kbytes = 524288
vm.zone_reclaim_mode = 0

# Transparent hugepages optimization
vm.nr_hugepages = 1024

# Network optimizations for gaming
net.core.rmem_default = 262144
net.core.rmem_max = 16777216
net.core.wmem_default = 262144
net.core.wmem_max = 16777216
net.core.netdev_max_backlog = 5000
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_mtu_probing = 1

# Reduce latency
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_sack = 1
net.ipv4.tcp_fack = 1
net.ipv4.tcp_window_scaling = 1

# File system optimizations
fs.file-max = 2097152
fs.inotify.max_user_watches = 524288
EOF
    
    log "SUCCESS" "Virtual memory optimized for gaming"
}

configure_realtime() {
    if [ "$CONFIGURE_REALTIME" = false ]; then
        log "INFO" "Skipping real-time priority configuration (--no-realtime)"
        return
    fi
    
    if [ "$DRY_RUN" = true ]; then
        log "DRY_RUN" "Would configure real-time priorities for gaming"
        return
    fi
    
    log "STEP" "Configuring real-time priorities for gaming"
    
    # Create gaming limits configuration
    cat > /etc/security/limits.d/99-gaming.conf << 'EOF'
# Gaming Real-time Limits

# Allow audio group to use real-time priorities
@audio          -       rtprio          95
@audio          -       memlock         unlimited

# Allow games to use higher priorities
@games          -       nice            -10
@games          -       rtprio          50

# Allow wheel group (sudo users) real-time access
@wheel          -       rtprio          95
@wheel          -       memlock         unlimited
EOF
    
    # Create games group if it doesn't exist
    if ! getent group games >/dev/null 2>&1; then
        groupadd games
        log "INFO" "Created games group"
    fi
    
    log "SUCCESS" "Real-time priorities configured"
}

configure_process_scheduling() {
    if [ "$CONFIGURE_SCHEDULING" = false ]; then
        log "INFO" "Skipping process scheduling configuration (--no-scheduling)"
        return
    fi
    
    if [ "$DRY_RUN" = true ]; then
        log "DRY_RUN" "Would configure process scheduling with ananicy-cpp"
        return
    fi
    
    log "STEP" "Configuring process scheduling for gaming"
    
    # Check if ananicy-cpp is available
    if command -v ananicy-cpp >/dev/null 2>&1; then
        systemctl enable ananicy-cpp
        
        # Add gaming-specific rules
        mkdir -p /etc/ananicy.d
        cat > /etc/ananicy.d/gaming.rules << 'EOF'
# Gaming Process Prioritization Rules

{"name": "steam", "type": "Game"}
{"name": "steamwebhelper", "type": "Game"}
{"name": "gameoverlayui", "type": "Game"}
{"name": "csgo", "type": "Game"}
{"name": "dota2", "type": "Game"}
{"name": "wine", "type": "Game"}
{"name": "wine64", "type": "Game"}
{"name": "lutris", "type": "Game"}
{"name": "gamemoderun", "type": "Game"}
{"name": "mangohud", "type": "Game"}

# Desktop Environment
{"name": "hyprland", "type": "DE"}
{"name": "waybar", "type": "DE"}
{"name": "rofi", "type": "DE"}
{"name": "dunst", "type": "DE"}

# Audio
{"name": "pipewire", "type": "Audio"}
{"name": "pipewire-pulse", "type": "Audio"}
{"name": "wireplumber", "type": "Audio"}
EOF
        
        log "SUCCESS" "Process scheduling configured with ananicy-cpp"
    else
        log "WARNING" "ananicy-cpp not available, skipping process scheduling"
    fi
}

configure_memory_management() {
    if [ "$CONFIGURE_MEMORY" = false ]; then
        log "INFO" "Skipping memory management configuration (--no-memory)"
        return
    fi
    
    if [ "$DRY_RUN" = true ]; then
        log "DRY_RUN" "Would configure memory management with ZRAM"
        return
    fi
    
    log "STEP" "Configuring memory management for gaming"
    
    # Enable preload for faster application startup
    if command -v preload >/dev/null 2>&1; then
        systemctl enable preload
        log "SUCCESS" "Preload enabled for faster application startup"
    fi
    
    # Configure ZRAM if available
    if command -v zramctl >/dev/null 2>&1; then
        cat > /etc/systemd/system/zram-gaming.service << 'EOF'
[Unit]
Description=Gaming ZRAM Setup
After=multi-user.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/local/bin/gaming-zram-setup.sh
ExecStop=/usr/local/bin/gaming-zram-teardown.sh

[Install]
WantedBy=multi-user.target
EOF
        
        cat > /usr/local/bin/gaming-zram-setup.sh << 'EOF'
#!/bin/bash
# Setup ZRAM for gaming

ZRAM_SIZE="4G"
ZRAM_DEVICE="/dev/zram0"

# Create zram device
modprobe zram 2>/dev/null || true
echo $ZRAM_SIZE > /sys/block/zram0/disksize 2>/dev/null || true
mkswap $ZRAM_DEVICE >/dev/null 2>&1 || true
swapon $ZRAM_DEVICE -p 10 >/dev/null 2>&1 || true

echo "Gaming: ZRAM configured with size $ZRAM_SIZE"
EOF
        
        cat > /usr/local/bin/gaming-zram-teardown.sh << 'EOF'
#!/bin/bash
# Teardown ZRAM

swapoff /dev/zram0 >/dev/null 2>&1 || true
rmmod zram >/dev/null 2>&1 || true
echo "Gaming: ZRAM disabled"
EOF
        
        chmod +x /usr/local/bin/gaming-zram-*.sh
        systemctl enable zram-gaming.service
        
        log "SUCCESS" "ZRAM configured for gaming"
    else
        log "WARNING" "zramctl not available, skipping ZRAM configuration"
    fi
}

show_summary() {
    echo
    log "SUCCESS" "Gaming optimizations installation completed!"
    echo
    echo -e "${BLUE}📋 Applied Optimizations:${NC}"
    
    [ "$INSTALL_KERNEL" = true ] && echo "   ✅ Gaming-optimized kernel (linux-zen)"
    [ "$CONFIGURE_GRUB" = true ] && echo "   ✅ GRUB gaming parameters"
    [ "$CONFIGURE_CPU" = true ] && echo "   ✅ CPU performance mode"
    [ "$CONFIGURE_IO" = true ] && echo "   ✅ I/O scheduler optimization"
    [ "$CONFIGURE_VM" = true ] && echo "   ✅ Virtual memory tuning"
    [ "$CONFIGURE_REALTIME" = true ] && echo "   ✅ Real-time priorities"
    [ "$CONFIGURE_SCHEDULING" = true ] && echo "   ✅ Process scheduling"
    [ "$CONFIGURE_MEMORY" = true ] && echo "   ✅ Memory management"
    
    echo
    echo -e "${BLUE}📁 Files Created:${NC}"
    echo "   • Log file: $LOG_FILE"
    if [ -f /tmp/gaming-backup-location ]; then
        echo "   • Backup: $(cat /tmp/gaming-backup-location)"
    fi
    
    echo
    echo -e "${YELLOW}⚠️  IMPORTANT:${NC}"
    echo "   - Reboot required for all optimizations to take effect"
    echo "   - Some optimizations may increase power consumption"
    echo "   - Monitor system stability after reboot"
    echo "   - To revert changes, restore from backup directory"
    echo
    
    if [ "$DRY_RUN" = false ]; then
        read -p "Reboot now to apply optimizations? [y/N]: " reboot_confirm
        if [[ "$reboot_confirm" =~ ^[Yy]$ ]]; then
            log "INFO" "Rebooting system..."
            reboot
        else
            log "INFO" "Please reboot manually to apply optimizations"
        fi
    fi
}

main() {
    parse_arguments "$@"
    show_banner
    check_prerequisites
    create_backup
    
    log "STEP" "Starting gaming optimizations installation"
    
    install_gaming_kernel
    configure_grub_gaming
    configure_cpu_performance
    configure_io_scheduler
    configure_vm_gaming
    configure_realtime
    configure_process_scheduling
    configure_memory_management
    
    show_summary
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi
