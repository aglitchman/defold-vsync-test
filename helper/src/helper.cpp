#define EXTENSION_NAME Helper
#define LIB_NAME "helper"
#define MODULE_NAME LIB_NAME

#include <stdio.h>
#include <dmsdk/sdk.h>

#if defined(_WIN32)
	#include <gl/GL.h>
#elif defined(__EMSCRIPTEN__)
#else
	#include <GLES2/gl2.h>
	#include <GLES2/gl2ext.h>
#endif

static int Helper_GetVendorInfo(lua_State *L)
{
	DM_LUA_STACK_CHECK(L, 1);

	const GLubyte* vendor = glGetString(GL_VENDOR);

	lua_pushfstring(L, "%s", vendor);

	return 1;
}

static int Helper_GetRendererInfo(lua_State *L)
{
	DM_LUA_STACK_CHECK(L, 1);

	const GLubyte* renderer = glGetString(GL_RENDERER);

	lua_pushfstring(L, "%s", renderer);

	return 1;
}

static int Helper_GetVersionInfo(lua_State *L)
{
	DM_LUA_STACK_CHECK(L, 1);

	const GLubyte* version = glGetString(GL_VERSION);

	lua_pushfstring(L, "%s", version);

	return 1;
}

static const luaL_reg Module_methods[] = {
	{"get_vendor_info", Helper_GetVendorInfo},
	{"get_renderer_info", Helper_GetRendererInfo},
	{"get_version_info", Helper_GetVersionInfo},
	{0, 0}};

static void LuaInit(lua_State *L)
{
	int top = lua_gettop(L);

	luaL_register(L, MODULE_NAME, Module_methods);

	lua_pop(L, 1);
	assert(top == lua_gettop(L));
}

dmExtension::Result AppInitializeVersionExtension(dmExtension::AppParams *params)
{
	return dmExtension::RESULT_OK;
}

dmExtension::Result InitializeVersionExtension(dmExtension::Params *params)
{
	LuaInit(params->m_L);
	return dmExtension::RESULT_OK;
}

dmExtension::Result AppFinalizeVersionExtension(dmExtension::AppParams *params)
{
	return dmExtension::RESULT_OK;
}

dmExtension::Result FinalizeVersionExtension(dmExtension::Params *params)
{
	return dmExtension::RESULT_OK;
}

dmExtension::Result UpdateVersionExtension(dmExtension::Params *params)
{

	return dmExtension::RESULT_OK;
}

DM_DECLARE_EXTENSION(EXTENSION_NAME, LIB_NAME, AppInitializeVersionExtension, AppFinalizeVersionExtension, InitializeVersionExtension, UpdateVersionExtension, 0, FinalizeVersionExtension)
