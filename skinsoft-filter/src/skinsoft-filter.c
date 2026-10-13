/*
OBS SkinSoft Filter
Copyright (C) 2026 Apps By Yasu + IA

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.
*/

#include "skinsoft-filter.h"

#include <obs-module.h>
#include <plugin-support.h>

struct skinsoft_filter {
	obs_source_t *source;
	gs_effect_t *effect;
	gs_eparam_t *hue_center_param;
	gs_eparam_t *hue_range_param;
	gs_eparam_t *sat_min_param;
	gs_eparam_t *sat_max_param;
	gs_eparam_t *luma_min_param;
	gs_eparam_t *luma_max_param;
	gs_eparam_t *mask_softness_param;
	gs_eparam_t *smooth_amount_param;
	gs_eparam_t *blur_radius_param;
	gs_eparam_t *detail_protection_param;
	gs_eparam_t *texture_restore_param;
	gs_eparam_t *show_mask_param;
	float hue_center;
	float hue_range;
	float sat_min;
	float sat_max;
	float luma_min;
	float luma_max;
	float mask_softness;
	float smooth_amount;
	float blur_radius;
	float detail_protection;
	float texture_restore;
	bool show_mask;
};

static const char *skinsoft_get_name(void *unused)
{
	UNUSED_PARAMETER(unused);
	return obs_module_text("SkinSoftFilter");
}

static float percent_setting(obs_data_t *settings, const char *name)
{
	return (float)obs_data_get_double(settings, name) / 100.0f;
}

static void skinsoft_update(void *data, obs_data_t *settings)
{
	struct skinsoft_filter *filter = data;

	filter->hue_center = percent_setting(settings, "hue_center");
	filter->hue_range = percent_setting(settings, "hue_range");
	filter->sat_min = percent_setting(settings, "sat_min");
	filter->sat_max = percent_setting(settings, "sat_max");
	filter->luma_min = percent_setting(settings, "luma_min");
	filter->luma_max = percent_setting(settings, "luma_max");
	filter->mask_softness = percent_setting(settings, "mask_softness");
	filter->smooth_amount = percent_setting(settings, "smooth_amount");
	filter->blur_radius = (float)obs_data_get_double(settings, "blur_radius");
	filter->detail_protection = percent_setting(settings, "detail_protection");
	filter->texture_restore = percent_setting(settings, "texture_restore");
	filter->show_mask = obs_data_get_bool(settings, "show_mask");
}

static void skinsoft_defaults(obs_data_t *settings)
{
	obs_data_set_default_double(settings, "hue_center", 8.0);
	obs_data_set_default_double(settings, "hue_range", 10.0);
	obs_data_set_default_double(settings, "sat_min", 12.0);
	obs_data_set_default_double(settings, "sat_max", 80.0);
	obs_data_set_default_double(settings, "luma_min", 18.0);
	obs_data_set_default_double(settings, "luma_max", 95.0);
	obs_data_set_default_double(settings, "mask_softness", 35.0);
	obs_data_set_default_double(settings, "smooth_amount", 65.0);
	obs_data_set_default_double(settings, "blur_radius", 4.0);
	obs_data_set_default_double(settings, "detail_protection", 35.0);
	obs_data_set_default_double(settings, "texture_restore", 20.0);
	obs_data_set_default_bool(settings, "show_mask", false);
}

static bool skinsoft_reset(obs_properties_t *props, obs_property_t *property, void *data)
{
	UNUSED_PARAMETER(props);
	UNUSED_PARAMETER(property);

	struct skinsoft_filter *filter = data;
	obs_data_t *settings = obs_source_get_settings(filter->source);

	skinsoft_defaults(settings);
	obs_source_update(filter->source, settings);
	obs_data_release(settings);

	return true;
}

static obs_properties_t *skinsoft_properties(void *data)
{
	obs_properties_t *props = obs_properties_create();
	obs_properties_t *mask_props = obs_properties_create();
	obs_properties_t *smooth_props = obs_properties_create();
	obs_properties_t *preview_props = obs_properties_create();

	obs_properties_add_bool(preview_props, "show_mask", obs_module_text("ShowMask"));

	obs_properties_add_float_slider(mask_props, "hue_center", obs_module_text("HueCenter"), 0.0, 100.0, 1.0);
	obs_properties_add_float_slider(mask_props, "hue_range", obs_module_text("HueRange"), 1.0, 50.0, 1.0);
	obs_properties_add_float_slider(mask_props, "sat_min", obs_module_text("SaturationMin"), 0.0, 100.0, 1.0);
	obs_properties_add_float_slider(mask_props, "sat_max", obs_module_text("SaturationMax"), 0.0, 100.0, 1.0);
	obs_properties_add_float_slider(mask_props, "luma_min", obs_module_text("LumaMin"), 0.0, 100.0, 1.0);
	obs_properties_add_float_slider(mask_props, "luma_max", obs_module_text("LumaMax"), 0.0, 100.0, 1.0);
	obs_properties_add_float_slider(mask_props, "mask_softness", obs_module_text("MaskSoftness"), 0.0, 100.0, 1.0);

	obs_properties_add_float_slider(smooth_props, "smooth_amount", obs_module_text("SmoothAmount"), 0.0, 100.0,
					1.0);
	obs_properties_add_float_slider(smooth_props, "blur_radius", obs_module_text("BlurRadius"), 0.0, 8.0, 0.25);
	obs_properties_add_float_slider(smooth_props, "detail_protection", obs_module_text("DetailProtection"), 0.0,
					100.0, 1.0);
	obs_properties_add_float_slider(smooth_props, "texture_restore", obs_module_text("TextureRestore"), 0.0, 100.0,
					1.0);

	obs_properties_add_group(props, "preview_group", obs_module_text("PreviewGroup"), OBS_GROUP_NORMAL, preview_props);
	obs_properties_add_group(props, "mask_group", obs_module_text("MaskGroup"), OBS_GROUP_NORMAL, mask_props);
	obs_properties_add_group(props, "smooth_group", obs_module_text("SmoothGroup"), OBS_GROUP_NORMAL, smooth_props);
	obs_properties_add_button(props, "reset", obs_module_text("Reset"), skinsoft_reset);

	UNUSED_PARAMETER(data);
	return props;
}

static void *skinsoft_create(obs_data_t *settings, obs_source_t *source)
{
	struct skinsoft_filter *filter = bzalloc(sizeof(*filter));
	char *effect_path = obs_module_file("effects/skinsoft.effect");

	filter->source = source;

	obs_enter_graphics();
	filter->effect = gs_effect_create_from_file(effect_path, NULL);
	obs_leave_graphics();

	if (!filter->effect) {
		obs_log(LOG_ERROR, "failed to load effect file: %s", effect_path);
	} else {
		filter->hue_center_param = gs_effect_get_param_by_name(filter->effect, "hue_center");
		filter->hue_range_param = gs_effect_get_param_by_name(filter->effect, "hue_range");
		filter->sat_min_param = gs_effect_get_param_by_name(filter->effect, "sat_min");
		filter->sat_max_param = gs_effect_get_param_by_name(filter->effect, "sat_max");
		filter->luma_min_param = gs_effect_get_param_by_name(filter->effect, "luma_min");
		filter->luma_max_param = gs_effect_get_param_by_name(filter->effect, "luma_max");
		filter->mask_softness_param = gs_effect_get_param_by_name(filter->effect, "mask_softness");
		filter->smooth_amount_param = gs_effect_get_param_by_name(filter->effect, "smooth_amount");
		filter->blur_radius_param = gs_effect_get_param_by_name(filter->effect, "blur_radius");
		filter->detail_protection_param = gs_effect_get_param_by_name(filter->effect, "detail_protection");
		filter->texture_restore_param = gs_effect_get_param_by_name(filter->effect, "texture_restore");
		filter->show_mask_param = gs_effect_get_param_by_name(filter->effect, "show_mask");
	}

	bfree(effect_path);
	skinsoft_update(filter, settings);

	return filter;
}

static void skinsoft_destroy(void *data)
{
	struct skinsoft_filter *filter = data;

	if (filter->effect) {
		obs_enter_graphics();
		gs_effect_destroy(filter->effect);
		obs_leave_graphics();
	}

	bfree(filter);
}

static void skinsoft_render(void *data, gs_effect_t *effect)
{
	struct skinsoft_filter *filter = data;

	UNUSED_PARAMETER(effect);

	if (!filter->effect) {
		obs_source_skip_video_filter(filter->source);
		return;
	}

	if (!obs_source_process_filter_begin(filter->source, GS_RGBA, OBS_NO_DIRECT_RENDERING)) {
		return;
	}

	gs_effect_set_float(filter->hue_center_param, filter->hue_center);
	gs_effect_set_float(filter->hue_range_param, filter->hue_range);
	gs_effect_set_float(filter->sat_min_param, filter->sat_min);
	gs_effect_set_float(filter->sat_max_param, filter->sat_max);
	gs_effect_set_float(filter->luma_min_param, filter->luma_min);
	gs_effect_set_float(filter->luma_max_param, filter->luma_max);
	gs_effect_set_float(filter->mask_softness_param, filter->mask_softness);
	gs_effect_set_float(filter->smooth_amount_param, filter->smooth_amount);
	gs_effect_set_float(filter->blur_radius_param, filter->blur_radius);
	gs_effect_set_float(filter->detail_protection_param, filter->detail_protection);
	gs_effect_set_float(filter->texture_restore_param, filter->texture_restore);
	gs_effect_set_bool(filter->show_mask_param, filter->show_mask);

	obs_source_process_filter_end(filter->source, filter->effect, 0, 0);
}

void register_skinsoft_filter(void)
{
	struct obs_source_info filter = {
		.id = "obs_skinsoft_filter",
		.type = OBS_SOURCE_TYPE_FILTER,
		.output_flags = OBS_SOURCE_VIDEO,
		.get_name = skinsoft_get_name,
		.create = skinsoft_create,
		.destroy = skinsoft_destroy,
		.update = skinsoft_update,
		.get_defaults = skinsoft_defaults,
		.get_properties = skinsoft_properties,
		.video_render = skinsoft_render,
	};

	obs_register_source(&filter);
}
