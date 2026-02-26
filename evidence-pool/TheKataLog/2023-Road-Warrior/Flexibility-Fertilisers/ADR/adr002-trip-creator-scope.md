# Context
When individual bookings get created in the system, they ultimately need to be grouped into a coherent trip that helps users track the legs of their trip easily and quickly get to relevant information.

# Decision
Ideally trips will be automatically created by some sort of ML task that recognizes related bookings. This however would be a big project by itself and even then we would need to have the ability to fallback to manual correction. Therefore, we will start with users needing to manually group bookings into a trip.

# Consequences
- Reduces the overhead of getting an initial version of Road Warrior out.
- Will still be useful for manual correction in the future.