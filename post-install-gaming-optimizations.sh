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
INSTALL_GAMING_APPS=true
INSTALL_DESKTOP=true
INSTALL_GPU_DRIVERS=true
INSTALL_AUDIO=true
DESKTOP_ENV="hyprland"
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
    --no-gaming-apps       Skip gaming applications installation
    --no-desktop           Skip desktop environment installation
    --no-gpu-drivers       Skip GPU drivers installation
    --no-audio             Skip audio system installation
    --desktop ENV          Desktop environment (hyprland, kde, gnome, i3)
    --interactive          Interactive mode (ask before each step) [NOT IMPLEMENTED]

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
    
    🎯 Gaming Software:
    • Steam, Lutris, GameMode, MangoHud
    • Wine, Bottles, Discord, OBS Studio
    • Tailscale (VPN for gaming networks)
    • Optimized Steam launcher
    
    🖥️ Desktop Environment:
    • Hyprland (default), KDE, GNOME, i3
    • Gaming-optimized configurations
    
    🎨 GPU Drivers:
    • NVIDIA (proprietary + OpenCL)
    • AMD (AMDGPU + Vulkan)
    • Intel (integrated graphics)
    
    🔊 Audio System:
    • PipeWire with low-latency configuration
    • Gaming audio optimizations
    
EXAMPLES:
    sudo ./post-install-gaming-optimizations.sh
    sudo ./post-install-gaming-optimizations.sh --dry-run
    sudo ./post-install-gaming-optimizations.sh --desktop kde --no-kernel
    sudo ./post-install-gaming-optimizations.sh --no-gaming-apps --no-desktop

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
            --no-gaming-apps)
                INSTALL_GAMING_APPS=false
                shift
                ;;
            --no-desktop)
                INSTALL_DESKTOP=false
                shift
                ;;
            --no-gpu-drivers)
                INSTALL_GPU_DRIVERS=false
                shift
                ;;
            --no-audio)
                INSTALL_AUDIO=false
                shift
                ;;
            --desktop)
                if [[ -z "$2" ]]; then
                    log "ERROR" "--desktop requires a value (hyprland, kde, gnome, i3)"
                    exit 1
                fi
                DESKTOP_ENV="$2"
                shift 2
                ;;
            --interactive)
                log "WARNING" "Interactive mode not yet implemented"
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
    
    # Update package database (full system upgrade)
    # Note: This performs a full system upgrade which may take time
    pacman -Syu --noconfirm
    
    # Check if linux-zen is available
    if pacman -Si linux-zen &>/dev/null; then
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
    if pacman -Si ananicy-cpp &>/dev/null; then
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
    
    # Check if GRUB config exists
    if [ ! -f /etc/default/grub ]; then
        log "ERROR" "GRUB configuration file not found at /etc/default/grub"
        log "WARNING" "Skipping GRUB configuration"
        return 0
    fi
    
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
    
    # Update GRUB configuration (using | as delimiter to avoid issues with / in parameters)
    if grep -q "GRUB_CMDLINE_LINUX_DEFAULT=" /etc/default/grub; then
        sed -i "s|GRUB_CMDLINE_LINUX_DEFAULT=\"[^\"]*\"|GRUB_CMDLINE_LINUX_DEFAULT=\"quiet $params_string\"|" /etc/default/grub
    else
        echo "GRUB_CMDLINE_LINUX_DEFAULT=\"quiet $params_string\"" >> /etc/default/grub
    fi
    
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
    for gov in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
        [ -w "$gov" ] && echo "performance" > "$gov" 2>/dev/null || true
    done
    echo "Gaming: CPU governor set to performance"
fi

# Disable CPU frequency scaling
if command -v cpupower >/dev/null 2>&1; then
    cpupower frequency-set -g performance >/dev/null 2>&1 || true
    echo "Gaming: CPU frequency scaling configured"
fi

# Set CPU performance bias
if [ -f /sys/devices/system/cpu/cpu0/power/energy_perf_bias ]; then
    for bias in /sys/devices/system/cpu/cpu*/power/energy_perf_bias; do
        [ -w "$bias" ] && echo 0 > "$bias" 2>/dev/null || true
    done
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
    systemctl daemon-reload
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
    systemctl daemon-reload
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
        systemctl enable ananicy-cpp.service
        
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
        systemctl enable preload.service
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
# Ensure zram device exists (some kernels need explicit creation)
if [ ! -e /dev/zram0 ] && [ -w /sys/class/zram-control/hot_add ]; then
    echo 1 > /sys/class/zram-control/hot_add 2>/dev/null || true
fi
# Wait a moment for device to be ready and set size
for i in {1..5}; do
    if [ -e /dev/zram0 ] && echo $ZRAM_SIZE > /sys/block/zram0/disksize 2>/dev/null; then
        break
    fi
    sleep 1
done
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
        
        chmod +x /usr/local/bin/gaming-zram-setup.sh /usr/local/bin/gaming-zram-teardown.sh
        systemctl daemon-reload
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
    [ "$INSTALL_GPU_DRIVERS" = true ] && echo "   ✅ GPU drivers"
    [ "$INSTALL_AUDIO" = true ] && echo "   ✅ Audio system (PipeWire)"
    [ "$INSTALL_GAMING_APPS" = true ] && echo "   ✅ Gaming applications"
    [ "$INSTALL_DESKTOP" = true ] && echo "   ✅ Desktop environment ($DESKTOP_ENV)"
    
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

install_gaming_applications() {
    if [ "$INSTALL_GAMING_APPS" = false ]; then
        log "INFO" "Skipping gaming applications installation (--no-gaming-apps)"
        return
    fi
    
    if [ "$DRY_RUN" = true ]; then
        log "DRY_RUN" "Would install gaming applications (Steam, Lutris, GameMode, etc.)"
        return
    fi
    
    log "STEP" "Installing gaming applications"
    
    # Core gaming packages
    local gaming_packages=(
        steam
        lutris
        gamemode
        lib32-gamemode
        mangohud
        lib32-mangohud
        wine
        wine-gecko
        wine-mono
        winetricks
        discord
        obs-studio
        goverlay
        tailscale
    )
    
    # Install packages that are available
    local available_packages=()
    for package in "${gaming_packages[@]}"; do
        if pacman -Si "$package" &>/dev/null; then
            available_packages+=("$package")
        else
            log "WARNING" "Package $package not available in repositories"
        fi
    done
    
    if [ ${#available_packages[@]} -gt 0 ]; then
        pacman -S --needed --noconfirm "${available_packages[@]}"
        log "SUCCESS" "Gaming applications installed: ${available_packages[*]}"
    fi
    
    # Enable GameMode service globally (for all users)
    if command -v gamemoded >/dev/null 2>&1; then
        systemctl --global enable gamemoded.service
        log "SUCCESS" "GameMode service enabled globally"
    fi
    
    # Enable Tailscale service
    if command -v tailscale >/dev/null 2>&1; then
        if systemctl enable --now tailscaled.service; then
            log "SUCCESS" "Tailscale service enabled and started"
        else
            log "WARNING" "Tailscale service enabled but failed to start (may need reboot)"
        fi
        log "INFO" "Run 'sudo tailscale up' to connect to your Tailscale network"
    fi
    
    # Configure Steam for optimal performance
    if command -v steam >/dev/null 2>&1; then
        # Create Steam launch options script
        mkdir -p /usr/local/bin
        cat > /usr/local/bin/steam-gaming << 'EOF'
#!/bin/bash
# Optimized Steam launcher

# Set gaming environment variables
export STEAM_RUNTIME_PREFER_HOST_LIBRARIES=0
export STEAM_RUNTIME_HEAVY=1
export RADV_PERFTEST=aco
export MESA_GL_VERSION_OVERRIDE=4.6
export __GL_THREADED_OPTIMIZATIONS=1
export __GL_SYNC_TO_VBLANK=0

# Launch Steam with GameMode
exec gamemoderun steam "$@"
EOF
        chmod +x /usr/local/bin/steam-gaming
        log "SUCCESS" "Optimized Steam launcher created"
    fi
    
    log "SUCCESS" "Gaming applications installation completed"
}

install_desktop_environment() {
    if [ "$INSTALL_DESKTOP" = false ]; then
        log "INFO" "Skipping desktop environment installation (--no-desktop)"
        return
    fi
    
    if [ "$DRY_RUN" = true ]; then
        log "DRY_RUN" "Would install desktop environment: $DESKTOP_ENV"
        return
    fi
    
    log "STEP" "Installing desktop environment: $DESKTOP_ENV"
    
    case "$DESKTOP_ENV" in
        hyprland)
            local hypr_packages=(
                hyprland
                waybar
                wofi
                foot
                mako
                grim
                slurp
                wl-clipboard
                xdg-desktop-portal-hyprland
                polkit-kde-agent
                qt5-wayland
                qt6-wayland
                sddm
            )
            
            # Install available packages
            local available_packages=()
            for package in "${hypr_packages[@]}"; do
                if pacman -Si "$package" &>/dev/null; then
                    available_packages+=("$package")
                fi
            done
            
            if [ ${#available_packages[@]} -gt 0 ]; then
                pacman -S --needed --noconfirm "${available_packages[@]}"
            else
                log "WARNING" "No Hyprland packages available in repositories"
            fi
            systemctl enable sddm.service || log "WARNING" "Failed to enable SDDM service"
            
            # Create basic Hyprland config
            mkdir -p /etc/skel/.config/hypr
            cat > /etc/skel/.config/hypr/hyprland.conf << 'EOF'
# Gaming-optimized Hyprland configuration

monitor=,preferred,auto,1

input {
    kb_layout = us
    follow_mouse = 1
    sensitivity = 0
}

general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)
    layout = dwindle
}

decoration {
    rounding = 5
    blur {
        enabled = true
        size = 3
        passes = 1
    }
    drop_shadow = yes
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
}

animations {
    enabled = yes
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

# Gaming optimizations
misc {
    disable_hyprland_logo = true
    disable_splash_rendering = true
    mouse_move_enables_dpms = true
    key_press_enables_dpms = true
    vrr = 1
}

# Key bindings
bind = SUPER, Return, exec, foot
bind = SUPER, Q, killactive,
bind = SUPER, M, exit,
bind = SUPER, E, exec, thunar
bind = SUPER, V, togglefloating,
bind = SUPER, R, exec, wofi --show drun
bind = SUPER, P, pseudo,
bind = SUPER, J, togglesplit,

# Gaming shortcuts
bind = SUPER, G, exec, steam-gaming
bind = SUPER, L, exec, lutris

# Move focus
bind = SUPER, left, movefocus, l
bind = SUPER, right, movefocus, r
bind = SUPER, up, movefocus, u
bind = SUPER, down, movefocus, d

# Switch workspaces
bind = SUPER, 1, workspace, 1
bind = SUPER, 2, workspace, 2
bind = SUPER, 3, workspace, 3
bind = SUPER, 4, workspace, 4
bind = SUPER, 5, workspace, 5

# Move active window to workspace
bind = SUPER SHIFT, 1, movetoworkspace, 1
bind = SUPER SHIFT, 2, movetoworkspace, 2
bind = SUPER SHIFT, 3, movetoworkspace, 3
bind = SUPER SHIFT, 4, movetoworkspace, 4
bind = SUPER SHIFT, 5, movetoworkspace, 5

# Window rules for gaming
windowrule = fullscreen, ^(steam_app_).*
windowrule = immediate, ^(steam_app_).*
windowrule = fullscreen, ^(lutris).*
windowrule = immediate, ^(cs2).*
windowrule = immediate, ^(dota2).*
EOF
            
            log "SUCCESS" "Hyprland installed with gaming optimizations"
            ;;
            
        kde)
            if pacman -S --needed --noconfirm plasma-meta kde-applications sddm; then
                systemctl enable sddm.service || log "WARNING" "Failed to enable SDDM service"
                log "SUCCESS" "KDE Plasma installed"
            else
                log "WARNING" "Failed to install KDE Plasma packages"
            fi
            ;;
            
        gnome)
            if pacman -S --needed --noconfirm gnome gnome-extra gdm; then
                systemctl enable gdm.service || log "WARNING" "Failed to enable GDM service"
                log "SUCCESS" "GNOME installed"
            else
                log "WARNING" "Failed to install GNOME packages"
            fi
            ;;
            
        i3)
            local i3_packages=(
                i3-wm
                i3status
                i3lock
                dmenu
                xorg-server
                xorg-xinit
                lightdm
                lightdm-gtk-greeter
            )
            if pacman -S --needed --noconfirm "${i3_packages[@]}"; then
                systemctl enable lightdm.service || log "WARNING" "Failed to enable LightDM service"
                log "SUCCESS" "i3 window manager installed"
            else
                log "WARNING" "Failed to install i3 packages"
            fi
            ;;
            
        *)
            log "ERROR" "Unsupported desktop environment: $DESKTOP_ENV"
            log "INFO" "Supported: hyprland, kde, gnome, i3"
            log "WARNING" "Skipping desktop environment installation"
            return 0
            ;;
    esac
    
    log "SUCCESS" "Desktop environment installation completed"
}

install_gpu_drivers() {
    if [ "$INSTALL_GPU_DRIVERS" = false ]; then
        log "INFO" "Skipping GPU drivers installation (--no-gpu-drivers)"
        return
    fi
    
    if [ "$DRY_RUN" = true ]; then
        log "DRY_RUN" "Would install GPU drivers based on detected hardware"
        return
    fi
    
    log "STEP" "Installing GPU drivers"
    
    # Detect GPU hardware
    local has_nvidia=false
    local has_amd=false
    local has_intel=false
    
    if lspci | grep -i nvidia >/dev/null 2>&1; then
        has_nvidia=true
        log "INFO" "NVIDIA GPU detected"
    fi
    
    if lspci | grep -i "amd\|ati" >/dev/null 2>&1; then
        has_amd=true
        log "INFO" "AMD GPU detected"
    fi
    
    if lspci | grep -i "intel.*graphics\|intel.*display" >/dev/null 2>&1; then
        has_intel=true
        log "INFO" "Intel GPU detected"
    fi
    
    # Install NVIDIA drivers
    if [ "$has_nvidia" = true ]; then
        log "INFO" "Installing NVIDIA drivers"
        local nvidia_packages=(
            nvidia
            nvidia-utils
            lib32-nvidia-utils
            nvidia-settings
            opencl-nvidia
            lib32-opencl-nvidia
        )
        
        if pacman -S --needed --noconfirm "${nvidia_packages[@]}"; then
            log "SUCCESS" "NVIDIA drivers installed"
        else
            log "WARNING" "Failed to install some NVIDIA packages"
        fi
    fi
    
    # Install AMD drivers
    if [ "$has_amd" = true ]; then
        log "INFO" "Installing AMD drivers"
        local amd_packages=(
            mesa
            lib32-mesa
            xf86-video-amdgpu
            vulkan-radeon
            lib32-vulkan-radeon
            libva-mesa-driver
            lib32-libva-mesa-driver
            mesa-vdpau
            lib32-mesa-vdpau
        )
        
        if pacman -S --needed --noconfirm "${amd_packages[@]}"; then
            log "SUCCESS" "AMD drivers installed"
        else
            log "WARNING" "Failed to install some AMD packages"
        fi
    fi
    
    # Install Intel drivers
    if [ "$has_intel" = true ]; then
        log "INFO" "Installing Intel drivers"
        local intel_packages=(
            mesa
            lib32-mesa
            vulkan-intel
            lib32-vulkan-intel
            intel-media-driver
            libva-intel-driver
        )
        
        if pacman -S --needed --noconfirm "${intel_packages[@]}"; then
            log "SUCCESS" "Intel drivers installed"
        else
            log "WARNING" "Failed to install some Intel packages"
        fi
    fi
    
    # Install common graphics packages
    local common_packages=(
        vulkan-tools
        vulkan-validation-layers
        lib32-vulkan-validation-layers
        mesa-demos
    )
    
    if pacman -S --needed --noconfirm "${common_packages[@]}"; then
        log "SUCCESS" "Common graphics packages installed"
    else
        log "WARNING" "Failed to install some common graphics packages"
    fi
    
    log "SUCCESS" "GPU drivers installation completed"
}

install_audio_system() {
    if [ "$INSTALL_AUDIO" = false ]; then
        log "INFO" "Skipping audio system installation (--no-audio)"
        return
    fi
    
    if [ "$DRY_RUN" = true ]; then
        log "DRY_RUN" "Would install PipeWire audio system with gaming optimizations"
        return
    fi
    
    log "STEP" "Installing audio system"
    
    # Install PipeWire
    local audio_packages=(
        pipewire
        lib32-pipewire
        wireplumber
        pipewire-alsa
        pipewire-pulse
        pipewire-jack
        lib32-pipewire-jack
        pavucontrol
    )
    
    if pacman -S --needed --noconfirm "${audio_packages[@]}"; then
        log "SUCCESS" "PipeWire packages installed"
    else
        log "WARNING" "Failed to install some PipeWire packages"
    fi
    
    # Enable PipeWire services globally for all users
    systemctl --global enable pipewire.service
    systemctl --global enable pipewire-pulse.service
    systemctl --global enable wireplumber.service
    
    # Create gaming audio configuration
    mkdir -p /etc/pipewire/pipewire.conf.d
    cat > /etc/pipewire/pipewire.conf.d/99-gaming.conf << 'EOF'
# Gaming audio optimizations
context.properties = {
    default.clock.rate = 48000
    default.clock.quantum = 64
    default.clock.min-quantum = 32
    default.clock.max-quantum = 2048
    core.daemon = true
    core.name = pipewire-0
}

context.spa-libs = {
    audio.convert.* = audioconvert/libspa-audioconvert
    support.* = support/libspa-support
}

context.modules = [
    { name = libpipewire-module-rt
        args = {
            nice.level = -11
            rt.prio = 88
            rt.time.soft = 200000
            rt.time.hard = 200000
        }
        flags = [ ifexists nofail ]
    }
    { name = libpipewire-module-protocol-native }
    { name = libpipewire-module-client-node }
    { name = libpipewire-module-adapter }
    { name = libpipewire-module-link-factory }
]
EOF
    
    log "SUCCESS" "PipeWire audio system installed with gaming optimizations"
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
    install_gpu_drivers
    install_audio_system
    install_gaming_applications
    install_desktop_environment
    
    show_summary
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi
