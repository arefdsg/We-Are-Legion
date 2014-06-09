using FragSharpFramework;

namespace GpuSim
{
    public partial class BuildingInfusion_Data : SimShader
    {
        [FragmentShader]
        building FragmentShader(VertexOut vertex, Field<unit> Unit, Field<building> Building)
        {
            building building_here = Building[Here];
            unit unit_here = Unit[Here];

            if (Something(building_here) && IsBuilding(unit_here) && IsCenter(building_here))
            {
                if (building_here.direction >= Dir.StationaryDead)
                {
                    building_here.direction += _1;
                    return building_here;
                }

                building
                    right = Building[RightOne],
                    up    = Building[UpOne],
                    left  = Building[LeftOne],
                    down  = Building[DownOne],
                    up_right   = Building[UpRight],
                    up_left    = Building[UpLeft],
                    down_right = Building[DownRight],
                    down_left  = Building[DownLeft];

                // If any part of the building is dying, then the center (and consequently the whole building) should be marked as dead.
                if (right     .direction == Dir.StationaryDying ||
                    up        .direction == Dir.StationaryDying ||
                    left      .direction == Dir.StationaryDying ||
                    down      .direction == Dir.StationaryDying ||
                    up_right  .direction == Dir.StationaryDying ||
                    up_left   .direction == Dir.StationaryDying ||
                    down_right.direction == Dir.StationaryDying ||
                    down_left .direction == Dir.StationaryDying)
                {
                    building_here.direction = Dir.StationaryDead;
                }

                // Select this center if any part of the building is selected
                if (!selected(building_here))
                {
                    bool is_selected =
                        selected(right)      ||
                        selected(up)         ||
                        selected(left)       ||
                        selected(down)       ||
                        selected(up_right)   ||
                        selected(up_left)    ||
                        selected(down_right) ||
                        selected(down_left);

                    set_selected(ref building_here, is_selected);
                }
            }

            return building_here;
        }
    }

    public partial class BuildingDiffusion_Data : SimShader
    {
        [FragmentShader]
        building FragmentShader(VertexOut vertex, Field<unit> Unit, Field<building> Building)
        {
            building building_here = Building[Here];
            unit unit_here = Unit[Here];

            if (Something(building_here) && IsBuilding(unit_here))
            {
                building center = Building[center_dir(building_here)];

                if (!Something(center)) return building.Nothing;

                building_here.prior_direction_and_select = center.prior_direction_and_select;
                building_here.direction = center.direction;
            }

            return building_here;
        }
    }

    public partial class BuildingDiffusion_Target : SimShader
    {
        [FragmentShader]
        vec4 FragmentShader(VertexOut vertex, Field<unit> Unit, Field<building> Building, Field<vec4> TargetData)
        {
            building building_here = Building[Here];
            unit unit_here = Unit[Here];
            vec4 target = TargetData[Here];

            if (Something(building_here) && IsBuilding(unit_here))
            {
                target = TargetData[center_dir(building_here)];
            }

            return target;
        }
    }
}
