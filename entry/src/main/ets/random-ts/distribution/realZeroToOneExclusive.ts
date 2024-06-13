import { Engine } from "../types";
import { SMALLEST_UNSAFE_INTEGER } from "../utils/constants";
import { uint53 } from "./uint53";

/**
 * Returns a floating-point value within [0.0, 1.0)
 */
export function realZeroToOneExclusive(engine: Engine): number {
  return uint53(engine) / SMALLEST_UNSAFE_INTEGER;
}
