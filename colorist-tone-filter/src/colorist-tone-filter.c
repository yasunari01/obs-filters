/*
OBS Colorist Tone Filter
Copyright (C) 2026 Apps By Yasu + IA

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.
*/

#include "colorist-tone-filter.h"

#include <obs-module.h>
#include <plugin-support.h>

struct colorist_tone_filter {
	obs_source_t *source;
	gs_effect_t *effect;
	gs_eparam_t *shadows_param;
	gs_eparam_t *lower_mids_param;
	gs_eparam_t *mids_param;
	gs_eparam_t *upper_mids_param;
	gs_eparam_t *highlights_param;
	gs_eparam_t *contrast_param;
	gs_eparam_t *pivot_param;
	gs_eparam_t *exposure_param;
	gs_eparam_t *mix_param;
	float shadows;
	float lower_mids;
	float mids;
	float upper_mids;
	float highlights;
	float contrast;
	float pivot;
	float exposure;
	float mix;
};

static const char *colorist_tone_get_name(void *unused)
{
	UNUSED_PARAMETER(unused);
	return obs_module_text("ColoristToneFilter");
}

static float slider_percent(obs_data_t *settings, const char *name)
{
	return (float)obs_data_get_double(settings, name) / 100.0f;
}

static void colorist_tone_update(void *data, obs_data_t *settings)
{
	struct colorist_tone_filter *filter = data;

	filter->shadows = slider_percent(settings, "shadows");
	filter->lower_mids = slider_percent(settings, "lower_mids");
	filter->mids = slider_percent(settings, "mids");
	filter->upper_mids = slider_percent(settings, "upper_mids");
	filter->highlights = slider_percent(settings, "highlights");
	filter->contrast = (float)obs_data_get_double(settings, "contrast") / 100.0f;
	filter->pivot = (float)obs_data_get_double(settings, "pivot") / 100.0f;
	filter->exposure = (float)obs_data_get_double(settings, "exposure");
	filter->mix = slider_percent(settings, "mix");
}

static void colorist_tone_defaults(obs_data_t *settings)
{
	obs_data_set_default_double(settings, "shadows", 0.0);
	obs_data_set_default_double(settings, "lower_mids", 0.0);
	obs_data_set_default_double(settings, "mids", 0.0);
	obs_data_set_default_double(settings, "upper_mids", 0.0);
	obs_data_set_default_double(settings, "highlights", 0.0);
	obs_data_set_default_double(settings, "contrast", 100.0);
	obs_data_set_default_double(settings, "pivot", 50.0);
	obs_data_set_default_double(settings, "exposure", 0.0);
	obs_data_set_default_double(settings, "mix", 100.0);
}

static bool colorist_tone_reset(obs_properties_t *props, obs_property_t *property, void *data)
{
	UNUSED_PARAMETER(props);
	UNUSED_PARAMETER(property);

	struct colorist_tone_filter *filter = data;
	obs_data_t *settings = obs_source_get_settings(filter->source);

	colorist_tone_defaults(settings);
	obs_source_update(filter->source, settings);
	obs_data_release(settings);

	return true;
}

static obs_properties_t *colorist_tone_properties(void *data)
{
	obs_properties_t *props = obs_properties_create();

	obs_properties_add_float_slider(props, "exposure", obs_module_text("Exposure"), -2.0, 2.0, 0.01);
	obs_properties_add_float_slider(props, "contrast", obs_module_text("Contrast"), 0.0, 200.0, 1.0);
	obs_properties_add_float_slider(props, "pivot", obs_module_text("Pivot"), 0.0, 100.0, 1.0);
	obs_properties_add_float_slider(props, "shadows", obs_module_text("Shadows"), -100.0, 100.0, 1.0);
	obs_properties_add_float_slider(props, "lower_mids", obs_module_text("LowerMids"), -100.0, 100.0, 1.0);
	obs_properties_add_float_slider(props, "mids", obs_module_text("Mids"), -100.0, 100.0, 1.0);
	obs_properties_add_float_slider(props, "upper_mids", obs_module_text("UpperMids"), -100.0, 100.0, 1.0);
	obs_properties_add_float_slider(props, "highlights", obs_module_text("Highlights"), -100.0, 100.0, 1.0);
	obs_properties_add_float_slider(props, "mix", obs_module_text("Mix"), 0.0, 100.0, 1.0);
	obs_properties_add_button(props, "reset", obs_module_text("Reset"), colorist_tone_reset);

	UNUSED_PARAMETER(data);
	return props;
}

static void *colorist_tone_create(obs_data_t *settings, obs_source_t *source)
{
	struct colorist_tone_filter *filter = bzalloc(sizeof(*filter));
	char *effect_path = obs_module_file("effects/colorist-tone.effect");

	filter->source = source;

	obs_enter_graphics();
	filter->effect = gs_effect_create_from_file(effect_path, NULL);
	obs_leave_graphics();

	if (!filter->effect) {
		obs_log(LOG_ERROR, "failed to load effect file: %s", effect_path);
	} else {
		filter->shadows_param = gs_effect_get_param_by_name(filter->effect, "shadows");
		filter->lower_mids_param = gs_effect_get_param_by_name(filter->effect, "lower_mids");
		filter->mids_param = gs_effect_get_param_by_name(filter->effect, "mids");
		filter->upper_mids_param = gs_effect_get_param_by_name(filter->effect, "upper_mids");
		filter->highlights_param = gs_effect_get_param_by_name(filter->effect, "highlights");
		filter->contrast_param = gs_effect_get_param_by_name(filter->effect, "contrast");
		filter->pivot_param = gs_effect_get_param_by_name(filter->effect, "pivot");
		filter->exposure_param = gs_effect_get_param_by_name(filter->effect, "exposure");
		filter->mix_param = gs_effect_get_param_by_name(filter->effect, "mix_amount");
	}

	bfree(effect_path);
	colorist_tone_update(filter, settings);

	return filter;
}

static void colorist_tone_destroy(void *data)
{
	struct colorist_tone_filter *filter = data;

	if (filter->effect) {
		obs_enter_graphics();
		gs_effect_destroy(filter->effect);
		obs_leave_graphics();
	}

	bfree(filter);
}

static void colorist_tone_render(void *data, gs_effect_t *effect)
{
	struct colorist_tone_filter *filter = data;

	UNUSED_PARAMETER(effect);

	if (!filter->effect) {
		obs_source_skip_video_filter(filter->source);
		return;
	}

	if (!obs_source_process_filter_begin(filter->source, GS_RGBA, OBS_NO_DIRECT_RENDERING)) {
		return;
	}

	gs_effect_set_float(filter->shadows_param, filter->shadows);
	gs_effect_set_float(filter->lower_mids_param, filter->lower_mids);
	gs_effect_set_float(filter->mids_param, filter->mids);
	gs_effect_set_float(filter->upper_mids_param, filter->upper_mids);
	gs_effect_set_float(filter->highlights_param, filter->highlights);
	gs_effect_set_float(filter->contrast_param, filter->contrast);
	gs_effect_set_float(filter->pivot_param, filter->pivot);
	gs_effect_set_float(filter->exposure_param, filter->exposure);
	gs_effect_set_float(filter->mix_param, filter->mix);

	obs_source_process_filter_end(filter->source, filter->effect, 0, 0);
}

void register_colorist_tone_filter(void)
{
	struct obs_source_info filter = {
		.id = "obs_colorist_tone_filter",
		.type = OBS_SOURCE_TYPE_FILTER,
		.output_flags = OBS_SOURCE_VIDEO,
		.get_name = colorist_tone_get_name,
		.create = colorist_tone_create,
		.destroy = colorist_tone_destroy,
		.update = colorist_tone_update,
		.get_defaults = colorist_tone_defaults,
		.get_properties = colorist_tone_properties,
		.video_render = colorist_tone_render,
	};

	obs_register_source(&filter);
}
