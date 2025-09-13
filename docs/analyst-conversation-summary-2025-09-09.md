**Title**
- Multiple Sonicator Control and Monitoring — Analyst Conversation Summary

**Date**
- 2025-09-09

**Participants**
- Mary (Analyst)
- Stephen (Product/Engineering)

**Purpose**
- Capture functional requirements and impacts to extend the mobile app to support controlling and monitoring up to four sonicators.

**Context**
- App: Flutter mobile (Android/iOS/Web) with Google Firebase Realtime Database (RTDB) on GCP.
- Standards: Company documentation and quality standards in `.axovia-flow/company-standards/`; config in `.bmad-core/core-config.yaml` and `.axovia-flow/flow-config.yaml`.
- Quality bar: Maintain ~85% automated test coverage across unit, widget, and acceptance tests.

**Approach Chosen**
- Progressive brainstorming flow (broad → focused → documented) to develop requirements.

**Key Requirements**
- User Interface
  - Provide a clear way to switch between sonicators (up to four).
  - Consider whether to show all sonicator I/O signals simultaneously or one-at-a-time with quick switching.
  - Ensure reactive, responsive layouts across device sizes.

- Database (Firebase RTDB)
  - Extend existing schema to store per-sonicator signals for up to four devices.
  - Add `active-sonicators` parameter, automatically populated by Multi Sonicator I/O hardware.
  - Verify and/or document the current RTDB schema in-repo; add missing docs if absent.

- Hardware Integration
  - Define how hardware publishes active sonicator set and per-sonicator telemetry.
  - Handle state changes when sonicators come online/offline; consider manual override for `active-sonicators`.

- Quality Assurance
  - Add tests to ensure backward compatibility with single-sonicator mode.
  - Expand widget tests for new UI components (switcher, dashboards).
  - Include end-to-end/acceptance tests to validate multi→single mode transitions and regressions.

**Constraints & Assumptions**
- Backward compatible with existing single-sonicator deployments.
- Follow PRD sharding and documentation structure in `docs/prd/` per company standards.
- Use existing tech stack; no major framework changes anticipated.

**Open Questions**
- UI pattern selection: tabbed switcher, segmented control, horizontal pager, or dashboard with per-card drill-in?
- Do operators need a consolidated “all sonicators” view with key KPIs, or is per-sonicator detail sufficient?
- Expected data update rates with 4 concurrent streams; any performance limits on low-end devices?
- Error handling behavior when `active-sonicators` changes mid-session; UX for unavailable devices.
- Access control: any role-based restrictions per sonicator or action?

**Proposed Next Steps**
- Document RTDB schema changes (draft JSON tree and field semantics) and add to repo.
- Decide on UI switching pattern with a quick wireframe and usability check.
- Define hardware → RTDB contract for `active-sonicators` and telemetry topics/paths.
- Write test plan covering unit, widget, and acceptance tests; add CI gates to protect single-sonicator mode.
- Update PRD with new functional and non-functional requirements; add acceptance criteria.

**Artifacts Referenced**
- `.bmad-core/core-config.yaml`, `.axovia-flow/flow-config.yaml`, `.axovia-flow/company-standards/*`.
- Existing project documentation in `docs/` (PRD, architecture).

**Decision Log**
- Use progressive brainstorming method for requirement capture (agreed during session).

**Risks**
- Increased UI complexity may affect operator clarity if all signals are shown simultaneously.
- RTDB schema expansion could introduce compatibility issues if not versioned/migrated carefully.
- Real-time performance with four concurrent devices on older hardware.

**Action Items**
- [ ] Add RTDB schema doc and propose `active-sonicators` flow.
- [ ] Spike UI switcher options; select and document one.
- [ ] Author/update tests to protect single-sonicator behavior.
- [ ] Update PRD with finalized requirements and acceptance criteria.

