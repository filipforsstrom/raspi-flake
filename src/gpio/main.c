#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <linux/gpio.h>

// Export this function to be called from C#
#ifdef __cplusplus
extern "C"
{
#endif

    // Simple test function
    int gpio_hello()
    {
        printf("Hello GPIO\n");
        return 42;
    }

    // Get GPIO chip info
    int gpio_get_chip_info(char *label_buffer, int label_size, char *name_buffer, int name_size, unsigned int *lines)
    {
        int fd;
        struct gpiochip_info info;

        fd = open("/dev/gpiochip0", O_RDONLY);
        if (fd < 0)
            return -1;

        int ret = ioctl(fd, GPIO_GET_CHIPINFO_IOCTL, &info);
        close(fd);

        if (ret < 0)
            return ret;

        // Copy data to buffers
        snprintf(label_buffer, label_size, "%s", info.label);
        snprintf(name_buffer, name_size, "%s", info.name);
        *lines = info.lines;

        return 0;
    }

#ifdef __cplusplus
}
#endif

// Keep the main function for standalone testing
int main(int argc, char **argv)
{
    printf("Hello GPIO\n");
    return 0;
}