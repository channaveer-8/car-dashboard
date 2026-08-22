#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/kobject.h>
#include <linux/sysfs.h>
#include <linux/debugfs.h>
#include <linux/fs.h>
#include <linux/uaccess.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Antigravity");
MODULE_DESCRIPTION("BeagleBone Black Vehicle Sensor Driver (sysfs & debugfs)");
MODULE_VERSION("1.0");

static struct kobject *vehicle_kobj = NULL;
static struct dentry *debug_dir = NULL;

static unsigned int speed_val = 0;
static unsigned int battery_val = 100;
static char door_val[16] = "closed";

// ----------------------------------------------------
// Sysfs Interfaces (/sys/kernel/vehicle/)
// ----------------------------------------------------

static ssize_t speed_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
{
    return sysfs_emit(buf, "%u\n", speed_val);
}

static ssize_t speed_store(struct kobject *kobj, struct kobj_attribute *attr, const char *buf, size_t count)
{
    int ret;
    ret = kstrtouint(buf, 10, &speed_val);
    if (ret < 0)
        return ret;
    printk(KERN_INFO "vehicle_sensor (sysfs): speed updated to %u\n", speed_val);
    return count;
}

static ssize_t battery_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
{
    return sysfs_emit(buf, "%u\n", battery_val);
}

static ssize_t battery_store(struct kobject *kobj, struct kobj_attribute *attr, const char *buf, size_t count)
{
    int ret;
    ret = kstrtouint(buf, 10, &battery_val);
    if (ret < 0)
        return ret;
    printk(KERN_INFO "vehicle_sensor (sysfs): battery updated to %u%%\n", battery_val);
    return count;
}

static ssize_t door_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
{
    return sysfs_emit(buf, "%s\n", door_val);
}

static ssize_t door_store(struct kobject *kobj, struct kobj_attribute *attr, const char *buf, size_t count)
{
    size_t copy_len = min(count, sizeof(door_val) - 1);
    memcpy(door_val, buf, copy_len);
    if (copy_len > 0 && door_val[copy_len - 1] == '\n')
        door_val[copy_len - 1] = '\0';
    else
        door_val[copy_len] = '\0';

    printk(KERN_INFO "vehicle_sensor (sysfs): door state updated to %s\n", door_val);
    return count;
}

static struct kobj_attribute speed_attribute = __ATTR(speed, 0664, speed_show, speed_store);
static struct kobj_attribute battery_attribute = __ATTR(battery, 0664, battery_show, battery_store);
static struct kobj_attribute door_attribute = __ATTR(door, 0664, door_show, door_store);

static struct attribute *attrs[] = {
    &speed_attribute.attr,
    &battery_attribute.attr,
    &door_attribute.attr,
    NULL,
};

static struct attribute_group attr_group = {
    .attrs = attrs,
};

// ----------------------------------------------------
// Debugfs Interfaces (/sys/kernel/debug/vehicle/)
// ----------------------------------------------------

static ssize_t debug_door_read(struct file *file, char __user *user_buf, size_t count, loff_t *ppos)
{
    char buf[20];
    int len = snprintf(buf, sizeof(buf), "%s\n", door_val);
    return simple_read_from_buffer(user_buf, count, ppos, buf, len);
}

static ssize_t debug_door_write(struct file *file, const char __user *user_buf, size_t count, loff_t *ppos)
{
    size_t len = min(count, sizeof(door_val) - 1);
    if (copy_from_user(door_val, user_buf, len))
        return -EFAULT;
    if (len > 0 && door_val[len - 1] == '\n')
        door_val[len - 1] = '\0';
    else
        door_val[len] = '\0';
    
    printk(KERN_INFO "vehicle_sensor (debugfs): door state updated to %s\n", door_val);
    return count;
}

static const struct file_operations debug_door_fops = {
    .open = simple_open,
    .read = debug_door_read,
    .write = debug_door_write,
};

// ----------------------------------------------------
// Module Initialization and Exit
// ----------------------------------------------------

static int __init vehicle_sensor_init(void)
{
    int ret;

    printk(KERN_INFO "vehicle_sensor: Initializing Vehicle Sensor Driver\n");

    // 1. Create sysfs entry /sys/kernel/vehicle/
    vehicle_kobj = kobject_create_and_add("vehicle", kernel_kobj);
    if (!vehicle_kobj) {
        printk(KERN_ERR "vehicle_sensor: Failed to create vehicle kobject under /sys/kernel/\n");
        return -ENOMEM;
    }

    // Create sysfs files
    ret = sysfs_create_group(vehicle_kobj, &attr_group);
    if (ret) {
        printk(KERN_ERR "vehicle_sensor: Failed to create sysfs attribute group\n");
        kobject_put(vehicle_kobj);
        return ret;
    }

    // 2. Create debugfs entry /sys/kernel/debug/vehicle/ (optional)
    debug_dir = debugfs_create_dir("vehicle", NULL);
    if (debug_dir) {
        debugfs_create_u32("speed", 0664, debug_dir, &speed_val);
        debugfs_create_u32("battery", 0664, debug_dir, &battery_val);
        debugfs_create_file("door", 0664, debug_dir, NULL, &debug_door_fops);
        printk(KERN_INFO "vehicle_sensor: debugfs entry created under /sys/kernel/debug/vehicle/\n");
    } else {
        printk(KERN_WARNING "vehicle_sensor: Failed to create debugfs entry (non-fatal)\n");
    }

    printk(KERN_INFO "vehicle_sensor: sysfs nodes initialized under /sys/kernel/vehicle/\n");
    return 0;
}

static void __exit vehicle_sensor_exit(void)
{
    printk(KERN_INFO "vehicle_sensor: Exiting Vehicle Sensor Driver\n");

    // Remove sysfs group and kobject
    sysfs_remove_group(vehicle_kobj, &attr_group);
    kobject_put(vehicle_kobj);

    // Remove debugfs entry
    debugfs_remove_recursive(debug_dir);
}

module_init(vehicle_sensor_init);
module_exit(vehicle_sensor_exit);
