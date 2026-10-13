/*
OBS Colorist Filters
Copyright (C) 2026 Apps By Yasu + IA

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.
*/

#include "temperature-tint-filter.h"

#include <obs-module.h>
#include <plugin-support.h>

struct temperature_tint_filter {
	obs_source_t *source;
	gs_effect_t *effect;
	gs_eparam_t *temperature_param;
	gs_eparam_t *tint_param;
	gs_eparam_t *mix_param;
	float temperature;
	float tint;
	float mix;
};

static const char *temperature_tint_get_name(void *unused)
{
	UNUSED_PARAMETER(unused);
	return obs_module_text("TemperatureTintFilter");
}

static void temperature_tint_update(void *data, obs_data_t *settings)
{
	struct temperature_tint_filter *filter = data;

	filter->temperature = (float)obs_data_get_double(settings, "temperature") / 100.0f;
	filter->tint = (float)obs_data_get_double(settings, "tint") / 100.0f;
	filter->mix = (float)obs_data_get_double(settings, "mix") / 100.0f;
}

static void temperature_tint_defaults(obs_data_t *settings)
{
	obs_data_set_default_double(settings, "temperature", 0.0);
	obs_data_set_default_double(settings, "tint", 0.0);
	obs_data_set_default_double(settings, "mix", 100.0);
}

static bool temperature_tint_reset(obs_properties_t *props, obs_property_t *property, void *data)
{
	UNUSED_PARAMETER(props);
	UNUSED_PARAMETER(property);

	struct temperature_tint_filter *filter = data;
	obs_data_t *settings = obs_source_get_settings(filter->source);

	obs_data_set_double(settings, "temperature", 0.0);
	obs_data_set_double(settings, "tint", 0.0);
	obs_data_set_double(settings, "mix", 100.0);
	obs_source_update(filter->source, settings);
	obs_data_release(settings);

	return true;
}

static obs_properties_t *temperature_tint_properties(void *data)
{
	obs_properties_t *props = obs_properties_create();

	obs_property_t *temperature_property = obs_properties_add_float_slider(props, "temperature",
		obs_module_text("Temperature"), -100.0, 100.0, 1.0);
	obs_property_set_long_description(temperature_property, obs_module_text("TemperatureHelp"));
	obs_properties_add_float_slider(props, "tint", obs_module_text("Tint"), -100.0, 100.0, 1.0);
	obs_properties_add_float_slider(props, "mix", obs_module_text("Mix"), 0.0, 100.0, 1.0);
	obs_properties_add_button(props, "reset", obs_module_text("Reset"), temperature_tint_reset);

	UNUSED_PARAMETER(data);
	return props;
}

static void *temperature_tint_create(obs_data_t *settings, obs_source_t *source)
{
	struct temperature_tint_filter *filter = bzalloc(sizeof(*filter));
	char *effect_path = obs_module_file("effects/temperature-tint.effect");

	filter->source = source;

	obs_enter_graphics();
	filter->effect = gs_effect_create_from_file(effect_path, NULL);
	obs_leave_graphics();

	if (!filter->effect) {
		obs_log(LOG_ERROR, "failed to load effect file: %s", effect_path);
	} else {
		filter->temperature_param = gs_effect_get_param_by_name(filter->effect, "temperature");
		filter->tint_param = gs_effect_get_param_by_name(filter->effect, "tint");
		filter->mix_param = gs_effect_get_param_by_name(filter->effect, "mix_amount");
	}

	bfree(effect_path);
	temperature_tint_update(filter, settings);

	return filter;
}

static void temperature_tint_destroy(void *data)
{
	struct temperature_tint_filter *filter = data;

	if (filter->effect) {
		obs_enter_graphics();
		gs_effect_destroy(filter->effect);
		obs_leave_graphics();
	}

	bfree(filter);
}

static void temperature_tint_render(void *data, gs_effect_t *effect)
{
	struct temperature_tint_filter *filter = data;

	UNUSED_PARAMETER(effect);

	if (!filter->effect) {
		obs_source_skip_video_filter(filter->source);
		return;
	}

	if (!obs_source_process_filter_begin(filter->source, GS_RGBA, OBS_NO_DIRECT_RENDERING)) {
		return;
	}

	gs_effect_set_float(filter->temperature_param, filter->temperature);
	gs_effect_set_float(filter->tint_param, filter->tint);
	gs_effect_set_float(filter->mix_param, filter->mix);

	obs_source_process_filter_end(filter->source, filter->effect, 0, 0);
}

void register_temperature_tint_filter(void)
{
	struct obs_source_info filter = {
		.id = "obs_colorist_temperature_tint_filter",
		.type = OBS_SOURCE_TYPE_FILTER,
		.output_flags = OBS_SOURCE_VIDEO,
		.get_name = temperature_tint_get_name,
		.create = temperature_tint_create,
		.destroy = temperature_tint_destroy,
		.update = temperature_tint_update,
		.get_defaults = temperature_tint_defaults,
		.get_properties = temperature_tint_properties,
		.video_render = temperature_tint_render,
	};

	obs_register_source(&filter);
}
