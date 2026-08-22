#include <stdio.h>
#include <unistd.h>
#include <gpiod.h>

int main(void)
{
	struct gpiod_chip *chip = gpiod_chip_open("/dev/gpiochip1");
	if(!chip)
	{
		perror("Open chip failed");
		return 1;
	}

	struct gpiod_line_settings *settings = gpiod_line_settings_new();
	gpiod_line_settings_set_direction(settings, GPIOD_LINE_DIRECTION_OUTPUT);

	struct gpiod_line_config *line_config = gpiod_line_config_new();
        unsigned int offset = 2;
	gpiod_line_config_add_line_settings(line_config, &offset, 1, settings);
	
	struct gpiod_request_config *req_config = gpiod_request_config_new();
	gpiod_request_config_set_consumer(req_config, "Test_GPIO");

	struct gpiod_line_request *request = gpiod_chip_request_lines(chip, req_config, line_config);
       if(!request)
	{
		perror("Line request failed");
		return 1;
	}

	for (int i = 0; i<5; i++)
	{
		gpiod_line_request_set_value(request, offset, GPIOD_LINE_VALUE_ACTIVE);
		sleep(1);
		gpiod_line_request_set_value(request, offset, GPIOD_LINE_VALUE_INACTIVE);
		sleep(1);
	}

	gpiod_line_request_release(request);
	gpiod_request_config_free(req_config);
	gpiod_line_config_free(line_config);
	gpiod_line_settings_free(settings);
	gpiod_chip_close(chip);
}
