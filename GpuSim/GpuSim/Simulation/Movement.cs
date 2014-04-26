using FragSharpFramework;

namespace GpuSim
{
    public partial class Movement_Phase1 : SimShader
    {
        [FragmentShader]
        unit FragmentShader(VertexOut vertex, UnitField Current)
        {
            unit here = Current[Here], output = unit.Nothing;

            // If something is here, they have the right to stay.
            if (Something(here))
            {
                output = here;
                output.change = Change.Stayed;
                return output;
            }

            // Otherwise, check each direction to see if something is incoming.
            unit
                right = Current[RightOne],
                up    = Current[UpOne],
                left  = Current[LeftOne],
                down  = Current[DownOne];

            if (right.action != UnitAction.Stopped && right.direction == Dir.Left)  output = right;
            if (up   .action != UnitAction.Stopped && up.direction    == Dir.Down)  output = up;
            if (left .action != UnitAction.Stopped && left.direction  == Dir.Right) output = left;
            if (down .action != UnitAction.Stopped && down.direction  == Dir.Up)    output = down;

            if (Something(output))
            {
                output.change = Change.Moved;
                return output;
            }
            else
            {
                output = here;
                output.change = Change.Stayed;
                return output;
            }
        }
    }

    public partial class Movement_Phase2 : SimShader
    {
        [FragmentShader]
        unit FragmentShader(VertexOut vertex, UnitField Current, UnitField Next)
        {
            unit next = Next[Here];
            unit here = Current[Here];

            unit ahead = Next[dir_to_vec(here.direction)];
            if (ahead.change == Change.Moved && ahead.direction == here.direction)
                next = unit.Nothing;

            set_prior_direction(ref next, next.direction);

            return next;
        }
    }

    public partial class Movement_Phase3 : SimShader
    {
        [FragmentShader]
        unit FragmentShader(VertexOut vertex, UnitField PreviousExtra, UnitField CurrentUnit)
        {
            unit here = CurrentUnit[Here], output = unit.Nothing;

            if (Something(here))
            {
                if (here.change == Change.Stayed)
                    output = PreviousExtra[Here];
                else
                    output = PreviousExtra[dir_to_vec(Reverse(prior_direction(here)))];
            }

            return output;
        }
    }

    public partial class Movement_Phase4_DirOnly : SimShader
    {
        [FragmentShader]
        unit FragmentShader(VertexOut vertex, UnitField Extra, UnitField Current, UnitField Paths_Right, UnitField Paths_Left, UnitField Paths_Up, UnitField Paths_Down)
        {
            unit here = Current[Here];

            if (Something(here))
            {
                unit path = unit.Nothing;

                unit extra = Extra[Here];

                if (extra.direction == Dir.Right) path = Paths_Right[Here];
                if (extra.direction == Dir.Left)  path = Paths_Left [Here];
                if (extra.direction == Dir.Up)    path = Paths_Up   [Here];
                if (extra.direction == Dir.Down)  path = Paths_Down [Here];

                if ((path.g > 0 || path.b > 0) && IsValid(path.direction))
                {
                    here.direction = path.direction;
                }
            }

            return here;
        }
    }

    public partial class Movement_Phase4 : SimShader
    {
        [FragmentShader]
        unit FragmentShader(VertexOut vertex, UnitField Extra1, Extra2Field Extra2, UnitField Current, UnitField Paths_Right, UnitField Paths_Left, UnitField Paths_Up, UnitField Paths_Down)
        {
            unit here = Current[Here];

            if (Something(here))
            {
                unit path = unit.Nothing;

                unit
                    right = Current[RightOne],
                    up    = Current[UpOne],
                    left  = Current[LeftOne],
                    down  = Current[DownOne];

                unit
                    right_path = Paths_Right[Here],
                    up_path    = Paths_Up   [Here],
                    left_path  = Paths_Left [Here],
                    down_path  = Paths_Down [Here];

                unit extra1 = Extra1[Here];
                extra2 extra2 = Extra2[Here];
                vec2 Destination = unpack_vec2((vec4)extra1);

                float cur_angle    = atan(vertex.TexCoords.y - Destination.y * Extra1.DxDy.y, vertex.TexCoords.x - Destination.x * Extra1.DxDy.x);
                cur_angle          = (cur_angle + 3.14159f) / (2 * 3.14159f);
                float target_angle = extra2.target_angle;

                //vec2 diff = Destination - vertex.TexCoords * Extra1.Size;
                //if (Destination.x > vertex.TexCoords.x * Extra.Size.x)
                //{
                //    path = right_path;

                //    if (!(abs(diff.y) < 10 && abs(diff.x) > 20))
                //    {
                //        if (Destination.y < vertex.TexCoords.y * Extra.Size.y)
                //        {
                //            if (cur_angle < target_angle || abs(diff.x) < 10 && abs(diff.y) > 20 || right_path.direction == Dir.Right && Something(right))
                //            {
                //                path = down_path;
                //                if (Something(down))
                //                    path = right_path;
                //            }
                //        }
                //        else
                //        {
                //            if (cur_angle > target_angle || abs(diff.x) < 10 && abs(diff.y) > 20 || right_path.direction == Dir.Right && Something(right))
                //            {
                //                path = up_path;
                //                if (Something(up))
                //                    path = right_path;
                //            }
                //        }
                //    }
                //}
                //else
                //{
                //    path = left_path;

                //    if (!(abs(diff.y) < 10 && abs(diff.x) > 20))
                //    {
                //        if (Destination.y < vertex.TexCoords.y * Extra.Size.y)
                //        {
                //            if (cur_angle > target_angle || abs(diff.x) < 10 && abs(diff.y) > 20 || left_path.direction == Dir.Left && Something(left))
                //            {
                //                path = down_path;
                //                if (Something(down))
                //                    path = left_path;
                //            }
                //        }
                //        else
                //        {
                //            if (cur_angle < target_angle || abs(diff.x) < 10 && abs(diff.y) > 20 || left_path.direction == Dir.Left && Something(left))
                //            {
                //                path = up_path;
                //                if (Something(up))
                //                    path = left_path;
                //            }
                //        }
                //    }
                //}

                if (Destination.x > vertex.TexCoords.x * Extra1.Size.x)
                {
                    path = right_path;

                    if (Destination.y < vertex.TexCoords.y * Extra1.Size.y)
                    {
                        if (cur_angle < target_angle || right_path.direction == Dir.Right && Something(right))
                        {
                            path = down_path;
                            if (Something(down))
                                path = right_path;
                        }
                    }
                    else
                    {
                        if (cur_angle > target_angle || right_path.direction == Dir.Right && Something(right))
                        {
                            path = up_path;
                            if (Something(up))
                                path = right_path;
                        }
                    }
                }
                else
                {
                    path = left_path;

                    if (Destination.y < vertex.TexCoords.y * Extra1.Size.y)
                    {
                        if (cur_angle > target_angle || left_path.direction == Dir.Left && Something(left))
                        {
                            path = down_path;
                            if (Something(down))
                                path = left_path;
                        }
                    }
                    else
                    {
                        if (cur_angle < target_angle || left_path.direction == Dir.Left && Something(left))
                        {
                            path = up_path;
                            if (Something(up))
                                path = left_path;
                        }
                    }
                }

                if ((path.g > 0 || path.b > 0) && IsValid(path.direction))
                {
                    here.direction = path.direction;
                }
            }

            return here;
        }
    }
}
