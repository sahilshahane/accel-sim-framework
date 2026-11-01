# Naming Conventions

Naming conventions used in the Accel-Sim and GPGPU-Sim C++ sources
(`gpu-simulator/`, including the `gpgpu-sim/` submodule).

Informal Hungarian-style prefixes. Not enforced by tooling; only formatting is
enforced (`.clang-format`, `BasedOnStyle: Google`). Everything is snake_case.

## Variable prefixes

| Prefix | Meaning | Examples |
|---|---|---|
| `m_` | Class/struct member (dominant, ~820 identifiers) | `m_gpgpu_sim`, `m_config`, `m_warp`, `m_L1D` |
| `g_` | Global, or a former global moved into a context class | `g_the_gpu`, `g_stream_manager`, `g_sim_active` |
| `sm_` | **Static member** (not "streaming multiprocessor"), usually uid counters | `stream_manager::sm_next_stream_uid`, `mem_fetch::sm_next_mf_request_uid` |
| `s_` | Static / former static | `s_g_pc_to_insn` |
| `p_` | Pointer or parameter (inconsistent, rare) | `p_break_insn` |
| `n_` / `num_` | Count of something | `n_simt_clusters`, `num_shader()` |

Stacked prefixes: `s_g_pc_to_insn` (gpgpu_context.h) is the only one in the
codebase — a legacy file-scope static global later moved into `gpgpu_context`.
Do not create new stacked prefixes; use the single prefix matching what the
variable is now.

## Type names

| Pattern | Meaning | Examples |
|---|---|---|
| `*_t` | Classes/structs | `warp_inst_t`, `shd_warp_t`, `kernel_info_t`, `inst_trace_t` |
| `*_ctx` | Large stateful component / state holder | `shader_core_ctx`, `GPGPUsim_ctx`, `gpgpu_context` |
| `*_config` | Holds parsed command-line options; has `reg_options()` | `gpgpu_sim_config`, `shader_core_config`, `memory_config`, `trace_config` |
| `trace_*` | Accel-Sim subclass overriding PTX-frontend hooks for trace mode | `trace_shader_core_ctx`, `trace_shd_warp_t`, `trace_kernel_info_t`, `trace_gpgpu_sim` |
| `exec_*` | GPGPU-Sim PTX-mode counterpart of the `trace_*` subclasses | `exec_shader_core_ctx` |
| `ALL_CAPS` | Macros, `#define` constants, enum values | `MAX_DST`, `WARP_SIZE`, `UREG`, `PRED` |

## Functions and options

- Accessors: `get_*`, `set_*`, `is_*`, `was_*` (`get_uid()`, `set_launched()`).
- `cycle()`: advance a component one clock tick (gpgpu_sim, shader_core_ctx, caches, dram).
- `print_*` / `*_print_stats`: stat output.
- `reg_options(option_parser_t opp)`: register config options; flags are `-gpgpu_*` / `-trace_*`.
- Legacy typos are part of the API (`the_cude_device`, `ptx_opcocde_latency_options`) —
  don't rename unless updating every caller.

## For new code

- Members `m_name`; static members `sm_name`; avoid new globals (they break
  multiple simulator instances, e.g. via the Python wrapper) — put shared
  state in `gpgpu_context` / `GPGPUsim_ctx` instead.
- New classes `name_t`, or `name_ctx` for big stateful components.
- Hardware/timing changes go in the GPGPU-Sim base classes; trace-interpretation
  changes go in the `trace_*` classes in `gpu-simulator/trace-driven/`.
- Run the matching `format-code.sh` before committing.
