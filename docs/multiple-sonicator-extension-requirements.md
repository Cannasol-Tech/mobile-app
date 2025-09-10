# Multiple Sonicator Control and Monitoring Extension - Functional Requirements

**Project:** Cannasol Technologies Mobile App - Phase 2 Brownfield Enhancement  
**Document Type:** Functional Requirements Specification  
**Created:** January 2025  
**Author:** Mary (Business Analyst)  
**Status:** Draft for Project Brief Integration  

---

## Executive Summary

This document defines the functional requirements for the Multiple Sonicator Control and Monitoring extension to the Cannasol Technologies Mobile Application. This enhancement enables simultaneous monitoring and control of up to 4 ultrasonic processing devices through a unified mobile interface.

**Scope:** Phase 2 of brownfield enhancement roadmap  
**Objective:** Enable monitoring and control of multiple ultrasonic processing devices simultaneously  
**Technical Approach:** Extend existing Flutter mobile app with enhanced UI and Firebase RTDB schema updates  

---

## User Interface Requirements

### UI-REQ-001: Multi-Sonicator Display

**Requirement:** All Sonicators Configuration and current State should be neatly displayed on the main screen of the application and configurable per sonicator where applicable.

**Details:**

- Display all connected sonicators simultaneously on main sonicator page
- Show real-time state information for each sonicator
- Provide per-sonicator configuration access
- Maintain existing swipe navigation (Sonicator, Pump, Tank)

### UI-REQ-002: Configuration Confirmation Dialogs

**Requirement:** All configuration changes must have confirmation dialogs.

**Details:**

- Every configuration modification requires user confirmation
- Clear confirmation/cancellation options
- Prevent accidental configuration changes

### UI-REQ-003: Single Image Display Strategy

**Requirement:** Single sonicator image with overlayed config/state displays is acceptable and may be preferred for efficiency.

**Details:**

- Reuse existing static sonicator image
- Overlay configuration and state information
- Optimize screen real estate usage

### UI-REQ-004: Responsive Design Priority

**Requirement:** Priority information for smaller screens must include Operating State, START/STOP button, all operating state information, and CT2000 Config button.

**Details:**

- **Priority Order (Small Screens):**
  1. Operating State (RUNNING/IDLE/OVERLOAD/OFF)
  2. START/STOP button
  3. All operating state information (dynamically shrunk)
  4. CT2000 Config button (opens configuration dialog)
- Dynamic scaling rather than hiding information
- Responsive design across all device sizes

### UI-REQ-005: Configuration Button Labeling

**Requirement:** CONFIG button displays as 'CT2000 Config'

**Details:**

- Clear, descriptive button labeling
- Consistent terminology across interface
- User-friendly configuration access

---

## Database Schema Requirements

### DB-REQ-001: CT2000 Configuration Object

**Requirement:** New Config Object added for CT2000 specific configuration

**Technical Specification:**

- **Path:** `Devices/{DEVICE-ID}/Config/CT2000/`
- **Type:** Object
- **Keys:** All configuration signals available per sonicator
- **Purpose:** Per-sonicator configuration management

### DB-REQ-002: CT2000 State Object

**Requirement:** New State Object added for CT2000 specific state information

**Technical Specification:**

- **Path:** `Devices/{DEVICE-ID}/State/CT2000/`
- **Type:** Object
- **Keys:** All available state signals per sonicator
- **Purpose:** Real-time state monitoring per sonicator

### DB-REQ-003: Global Amplitude Control

**Requirement:** New Configuration parameter added for AMPLITUDE_ALL signal

**Technical Specification:**

- **Path:** `Devices/{DEVICE-ID}/Config/`
- **Key:** `sonic_amp_all`
- **Type:** INT (20-100)
- **Restrictions:**
  - Must be Integer
  - Must be >= 20
  - Must be <= 100
- **Purpose:** Controls operating amplitude for all connected sonicators

---

## Hardware Integration Requirements

### HW-REQ-001: Real-time State Streaming

**Requirement:** Real-time display of CT2000 State information streamed by hardware

**Details:**

- Mobile app receives real-time state updates
- Display updates reflect hardware state changes immediately
- No polling required - push-based updates

### HW-REQ-002: Configuration Change Interface

**Requirement:** Provide UI for users to modify CT2000 Config values in database

**Details:**

- Mobile app writes configuration changes to Firebase RTDB
- Hardware monitoring handled by separate project
- Clean separation of concerns

### HW-REQ-003: Global Amplitude Control Interface

**Requirement:** Provide UI for users to set sonic_amp_all parameter in database

**Details:**

- Mobile app provides interface for global amplitude control
- Hardware distribution handled externally
- Database-mediated communication pattern

---

## Quality Assurance Requirements

### QA-REQ-001: BDD Scenario Mapping

**Requirement:** Complete project brief → Full FR definitions in PRD → BDD scenarios mapping per company standards

**Details:**

- Follow company standards in `.axovia-flow/company-standards/`
- Map all functional requirements to BDD scenarios
- Ensure comprehensive test coverage

### QA-REQ-002: Flutter Testing Standards

**Requirement:** Multi-sonicator testing must follow Flutter testing framework standards

**Technical Specification:**

- **Unit Tests:** Business logic for multi-sonicator state management, configuration validation, amplitude control
- **Widget Tests:** UI components for sonicator displays, configuration dialogs, START/STOP buttons, responsive layouts
- **Integration Tests:** End-to-end multi-sonicator workflows, database integration, real-time state updates
- **Coverage Target:** 85% minimum per company standards
- **Testing Tools:** mocktail, flutter_test, integration_test framework

**Specific Test Scenarios:**

- Backwards compatibility (single sonicator operation unchanged)
- Multi-device support (1, 2, 3, and 4 sonicator configurations)
- UI responsiveness (all screen sizes with priority information display)
- Configuration management (CT2000 config changes with confirmation dialogs)
- Global controls (sonic_amp_all parameter functionality)
- Real-time updates (state streaming and display accuracy)

---

## Critical User Flows for Testing

### Flow 1: Multi-Sonicator Monitoring

User opens sonicator page → Views all sonicator states simultaneously → Verifies real-time state updates display correctly

### Flow 2: Individual Sonicator Control

User selects specific sonicator → Clicks START/STOP button → Confirms state change reflects in UI

### Flow 3: Per-Sonicator Configuration

User clicks 'CT2000 Config' on specific sonicator → Modifies CT2000 config values → Confirms via dialog → Verifies changes saved

### Flow 4: Global Amplitude Control

User accesses sonic_amp_all control → Sets value (20-100) → Confirms via dialog → Verifies all sonicators reflect change

### Flow 5: Responsive Design Validation

User rotates device/changes screen size → Verifies priority info displays (state, START/STOP, CT2000 Config button) → Tests config dialog accessibility

### Flow 6: Backwards Compatibility

User with single sonicator setup → Navigates sonicator page → Verifies existing functionality unchanged

### Flow 7: Multi-Device State Management

User with 2-4 sonicators → Views different operating states (RUNNING/IDLE/OVERLOAD/OFF) → Verifies clear visual distinction

### Flow 8: Configuration Dialog Management

User opens CT2000 Config dialog → Verifies proper modal behavior → Tests confirmation/cancellation flows

---

## Stretch Goals

### Future Enhancements (Not Required for MVP)

- Multiple simultaneous configuration dialogs
- Advanced device grouping and categorization
- Batch configuration operations
- Enhanced device synchronization features

---

## Implementation Notes

### Project Scope Boundaries

- **In Scope:** Mobile app UI, Firebase RTDB schema updates, user interface flows
- **Out of Scope:** Hardware communication protocols, hardware-to-database integration
- **Dependencies:** Hardware project handles database monitoring and signal distribution

### Company Standards Compliance

- Follow `.axovia-flow/company-standards/` documentation requirements
- Maintain 85% test coverage per company standards
- Implement BDD scenarios for all functional requirements
- Use established Flutter testing frameworks (mocktail, flutter_test, integration_test)

---

**Document Status:** Ready for Project Brief Integration  
**Next Steps:** Integrate requirements into main project brief documentation  
**Review Required:** Technical team validation of database schema specifications  

---

*This document was generated through structured brainstorming session facilitated by Mary (Business Analyst) following company standards and progressive technique flow methodology.*
